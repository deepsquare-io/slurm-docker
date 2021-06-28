#!/bin/bash

set -m

# Munge
cp /secrets/munge.key /etc/munge/munge.key && chown munge: /etc/munge/munge.key
su -s /bin/bash -c munged munge

# SSSD
rm -f /var/run/sssd.pid
/etc/init.d/sssd restart

while ! id slurm
do
  sleep 1
done

# Slurm
mkdir -p /var/log/slurm
mkdir -p /var/spool/slurm
mkdir -p /var/run/slurm
chown -R slurm: /var/spool/slurm /var/run/slurm
slurmd

sleep 2

env SLURM_JWT=daemon slurmrestd -vvvvv 0.0.0.0:6820 >> /var/log/slurm/slurmrestd.log &

sleep 2

tail -f /var/log/slurm/slurmd.log -f /var/log/slurm/slurmrestd.log
