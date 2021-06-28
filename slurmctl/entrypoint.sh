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
slurmctld

# Log to stdout
tail -f /var/log/slurm/slurmctld.log
