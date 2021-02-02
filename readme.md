# SlurmCtl (Ubuntu) Docker image

Docker image to run the Slurmctl daemon `slurmctld` as well as the Munge service `munged` for cluster authentication and the security service daemon `sssd` for the LDAP integration. Slurmctl is run in the foreground to have its output in `docker logs`. `munged` is run under user `munge`, and `SLURM_CONF` is set to `/etc/slurm/slurm.conf`.

## Configuration files
The services require a range of configuration files:

| Name & role | Mount path inside container | Source | 
| - | - | - |
| SSSD configuration | `/etc/sssd/sssd.conf` | NFS volume, folder `configurations` |
| SSSD - LDAP CA certificate | `/etc/pki/ldap-certificate.pem` | NFS volume, folder `configurations` |
| Munge key | `/etc/munge/munge.key` | NFS volume, folder `secrets` |
| SlurmRestd JWT HS256 key | inside Slurm state directory | NFS volume, folder `secrets` |
| Slurm configurations | `/etc/slurm/<file>` | NFS volume, folder `configurations/slurm` |

## Image build
- Add the Slurm `.deb` package to the build environment as `./build_env/slurm.deb`
- From the project root (the folder this file is in), run `docker build -t slurmctl:<slurm version> ./build_env`

To run the generated image without having to specify the Slurm version every time, run `docker tag slurmctl:<slurm version> slurmctl`. Then `slurmctl` may be used as shorthand.

## Container run
Beside the configuration files mounted from the host, `slurmctl`'s state directory should be put in a volume in order to be persisted. Same for logs.

Before running the container for the first time, create 2 volumes: `docker volume create slurmctl-state`, `docker volume create slurmctl-log`

The `entrypoint.sh` script will take care to "install" the secrets, which should be mounted to `/secrets`, to the right location:
- `/secrets/munge.key` to `/etc/munge/munge.key`
- `/secrets/jwt_hs256.key` to the `StateSaveDir` specified in the `slurm.conf`

`docker run` parameters:
- mount the expected configuration files mentioned above, all read-only
- mount docker volume `slurmctl-state` to the `StateSaveDir` specified in the `slurm.conf` (usually a spool directory) and `slurmctl-log` to the log directory
- expose the port `6817` 
- set the hostname to the `SlurmctldHost` specified in the `slurm.conf` with the `-h` flag

On the current host, it becomes:
```bash
#! /bin/bash

volume_root_path="/home/user/nfs-mount"

docker run -v "$volume_root_path/configurations/ldap_certificate.pem":/etc/pki/ldap-certificate.pem:ro -v "$volume_root_path/configurations/sssd.conf":/etc/sssd/sssd.conf:ro \
           -v "$volume_root_path/secrets":/secrets:ro -v "$volume_root_path/configurations/slurm":/etc/slurm:ro \
           -v slurmctl-state:/var/spool/slurm -v slurmctl-log:/var/log/slurm/ -h slurmctl -p 6817:6817 -d slurmctl
```
