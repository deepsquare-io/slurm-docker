#!/bin/sh
docker build . -t ghcr.io/squarefactory/slurm:21.08.8-2-controller --target slurm-controller
docker build . -t ghcr.io/squarefactory/slurm:21.08.8-2-login --target slurm-login
docker build . -t ghcr.io/squarefactory/slurm:21.08.8-2-rest --target slurm-rest
docker build . -t ghcr.io/squarefactory/slurm:21.08.8-2-db --target slurm-db
docker build . -t ghcr.io/squarefactory/slurm:21.08.8-2-compute --target slurm-compute
