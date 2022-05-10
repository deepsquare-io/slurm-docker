#! /bin/bash

docker run -v "/etc/ssl/certs/ldap-certificate.pem":/etc/ssl/certs/ldap-certificate.pem:ro \
           -v "/etc/sssd/sssd.conf":/etc/sssd/sssd.conf:ro \
           -v "$(pwd)/secrets/munge.key":/secrets/munge.key:ro \
           -v "$(pwd)/secrets/jwt_hs256.key":/secrets/jwt_hs256.key:ro \
           -v "$(pwd)/conf":/etc/slurm:ro \
           -v slurmctl-state:/var/spool/slurmctl \
           -v slurmctl-log:/var/log/slurm/ \
           -h slurmctl -p 6817:6817 \
           --expose 6817 \
           --name slurm-controller \
           --restart always \
           -d slurmctl
