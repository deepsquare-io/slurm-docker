#!/bin/sh
slurm_version=22.05.0-1
docker build . -t ghcr.io/squarefactory/slurm:${slurm_version}-controller --target slurm-controller
docker build . -t ghcr.io/squarefactory/slurm:${slurm_version}-login --target slurm-login
docker build . -t ghcr.io/squarefactory/slurm:${slurm_version}-rest --target slurm-rest
docker build . -t ghcr.io/squarefactory/slurm:${slurm_version}-db --target slurm-db
docker build . -t ghcr.io/squarefactory/slurm:${slurm_version}-compute --target slurm-compute
