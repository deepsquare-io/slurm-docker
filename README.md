# Slurm Docker

## Slurm DBD

### Network

- `6819/tcp`, slurm db port

### Volumes

- `/archive:rw`: SLURM archive
- `/etc/slurm:rw`: slurm configuration directory (including epilogs, prologs and spank configuration files)
- `/secrets/sssd:ro`: SSSD configuration files
- `/secrets/munge:ro`: MUNGE configuration files
- `/secrets/slurm:ro`: SLURM JWT Key

## Slurm Controller

### Network

- `6817/tcp`, slurm controller port.

### Volumes

- `/var/spool/slurmctl:rw`: SLURM controller state. Must be mounted on a persistent volume.
- `/etc/slurm:rw`: slurm configuration directory (including epilogs, prologs and spank configuration files)
- `/secrets/sssd:ro`: SSSD configuration files
- `/secrets/munge:ro`: MUNGE configuration files
- `/secrets/slurm:ro`: SLURM JWT Key

## Slurm Login

### Network

Use ipvlan/macvlan network to be able to run `srun` commands.

Ports:

- `22/tcp`, ssh
- `srunPortRange`

### Volumes

- `/etc/slurm:rw`: slurm configuration directory slurm configuration directory (including spank configuration files)
- `/secrets/sssd:ro`: SSSD configuration files
- `/secrets/munge:ro`: MUNGE configuration files
- `/secrets/sshd:ro`: SSHD host keys and SSHD config files

## Slurm REST

### Network

- `6820/tcp`, HTTP REST API. Do not bind to host, use nginx over it.

### Volumes

- `/etc/slurm:rw`: slurm configuration directory (including configuration files)
- `/secrets/sssd:ro`: SSSD configuration files
- `/secrets/munge:ro`: MUNGE configuration files
- `/secrets/slurm:ro`: SLURM JWT Key

## Slurm Daemon

### Network

Use host network.

### Volumes

- `/var/spool/slurmd:rw`: SLURM Daemon state
- `/etc/slurm:rw`: slurm configuration directory (including epilogs, prologs and spank configuration files)
- `/secrets/sssd:ro`: SSSD configuration files
- `/secrets/munge:ro`: MUNGE configuration files

## Running

```sh
docker-compose up -d --build
```
