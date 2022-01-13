#!/bin/bash

set -m

# Munge
cp /secrets/munge.key /etc/munge/munge.key
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
mkdir -p /var/log/slurm
cp /secrets/jwt_hs256.key /var/spool/slurmctl/jwt_hs256.key
chown -R slurm: /var/spool/{slurmctl,slurm} /var/run/{slurmctl,slurm}

if [ "$1" = "slurmdbd" ]
then
slurmdbd -D

fi

if [ "$1" = "slurmctld" ]
then
echo "Waiting slurmdb to launch on 6819..."

while ! nc -z 127.0.0.1 6819; do
  sleep 0.2
done

echo "slurmdb connected."

slurmctld -D

fi

if [ "$1" = "slurmd" ]
then
echo "Waiting slurmctl to launch on 6817..."

while ! nc -z 127.0.0.1 6817; do
  sleep 0.2
done

echo "slurmctl connected."

slurmd -D &

su -s /bin/sh -c "env SLURM_JWT=daemon slurmrestd 127.0.0.1:6820" api &

wait

fi
