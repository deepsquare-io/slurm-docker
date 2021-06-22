#! /bin/bash

volume_root_path="/home/user/nfs-mount"

docker run -v "$volume_root_path/configurations/ldap_certificate.pem":/etc/pki/ldap-certificate.pem:ro -v "$volume_root_path/configurations/sssd.conf":/etc/sssd/sssd.conf:ro \
           -v "$volume_root_path/secrets":/secrets:ro -v "$volume_root_path/configurations/slurm":/etc/slurm:ro \
           -v slurmctl-state:/var/spool/slurm -v slurmctl-log:/var/log/slurm/ \
           -h slurmctl -p 6817:6817 --add-host cn1:10.10.0.51 --add-host cn2:10.10.0.52 --add-host cn3:10.10.0.53 --add-host cn4:10.10.0.54 --add-host cn5:10.10.0.55 \
           -d --name slurm-controller --restart always slurmctl
