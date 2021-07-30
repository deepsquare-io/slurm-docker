#!/bin/bash

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
rm -rf /var/run/slurm/*.pid
rm -rf /var/run/slurm*.pid
mkdir -p /var/spool/slurmctl
mkdir -p /var/run/slurmctl
mkdir -p /var/log/slurm
mkdir -p /var/spool/slurm
mkdir -p /var/run/slurm && cp /secrets/jwt_hs256.key /var/spool/slurmctl/
chown -R slurm: /var/spool/slurm /var/run/slurm /var/run/slurmctl /var/spool/slurmctl
slurmctld -D

### Debug: start slurmctld in background and tail log instead - container remains up even if slurmctld crashes
#slurmctld
#tail -f /var/log/slurm/ctld.log
###
