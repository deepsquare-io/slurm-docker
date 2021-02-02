#! /bin/bash

# Munge
cp /secrets/munge.key /etc/munge/munge.key && chown munge: /etc/munge/munge.key
su -s /bin/bash -c munged munge

# SSSD
sssd

# Slurm
mkdir /var/run/slurm && cp /secrets/jwt_hs256.key /var/spool/slurm/ctld/
chown -R slurm: /var/spool/slurm /var/run/slurm
slurmctld -D