#! /bin/bash

# Munge
cp /secrets/munge.key /etc/munge/munge.key && chown munge: /etc/munge/munge.key
su -s /bin/bash -c munged munge

# SSSD
rm -rf /var/run/sssd.pid
/etc/init.d/sssd restart

# Slurm
mkdir /var/run/slurm && cp /secrets/jwt_hs256.key /var/spool/slurm/ctld/
chown -R slurm: /var/spool/slurm /var/run/slurm
slurmctld -D

### Debug: start slurmctld in background and tail log instead - container remains up even if slurmctld crashes
#slurmctld
#tail -f /var/log/slurm/ctld.log
###
