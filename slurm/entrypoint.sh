#!/bin/bash

set -m

# Munge
cp /secrets/munge.key /etc/munge/munge.key || echo "Copy file has failed"
chown munge: /etc/munge/munge.key
su -s /bin/bash -c munged munge

# SSSD
rm -f /var/run/sssd.pid
/etc/init.d/sssd restart

while ! id slurm
do
  sleep 1
done

# Slurm Controller
mkdir -p /var/{spool,run}/{slurm,slurmctl}
mkdir -p /var/log/slurm/
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cat << END > /root/.ssh/config
Host *
  StrictHostKeyChecking no
END
chown -R slurm:slurm /home/ldap-users/slurm/
cp /secrets/jwt_hs256.key /var/spool/slurmctl/jwt_hs256.key || echo "Copy file has failed"
chown -R slurm: /var/spool/{slurmctl,slurm} /var/run/{slurmctl,slurm}

if [ "$1" = "slurmdbd" ]
then
slurmdbd -D

sleep 2

tail  -f /var/log/slurm/slurmdbd.log
fi

if [ "$1" = "slurmctld" ]
then
echo "Waiting slurmdb to launch on 6819..."

while ! nc -z slurmdbd.csquare.gcloud 6819; do
  sleep 0.2
done
rm -rf /var/run/slurmctld.pid

slurmctld -D
fi

if [ "$1" = "slurmd" ]
then
echo "Waiting slurmctl to launch on 6817..."

while ! nc -z 127.0.0.1 6817; do
  sleep 0.2
done

slurmd -D &

sleep 2

env SLURM_JWT=daemon slurmrestd -vvvvv 0.0.0.0:6820 &

sleep 2

wait

fi
