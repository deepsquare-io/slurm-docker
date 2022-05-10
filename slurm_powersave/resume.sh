#!/bin/bash

set -e

echo "Resume script called with the parameters: $@" >> /var/log/slurm/powersave.log

hosts=$(scontrol show hostnames $1)
for host in $hosts
do
  ssh -i /slurm_powersave/slurmctl-keypair/id_rsa -o StrictHostKeyChecking=no slurmctl@10.10.64.10 "sudo /slurm_powersave/resume.sh '$host'" >> /var/log/slurm/resume.log &
done

echo "Resume script finished with the parameters: $@" >> /var/log/slurm/powersave.log
