#!/bin/sh -ex

slurm_version=23.11.5-1
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-controller --target slurm-controller
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-login --target slurm-login
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-rest --target slurm-rest
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-db --target slurm-db
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-compute --target slurm-compute
docker build . -f Dockerfile.rocky9.2 -t ghcr.io/squarefactory/slurm:${slurm_version}-prometheus-exporter --target slurm-prometheus-exporter
