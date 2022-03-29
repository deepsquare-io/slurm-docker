#!/bin/sh
docker build . -t ghcr.io/squarefactory/slurm-docker:0.1.0-slurmctl-reindeer --target slurm-slurmctld
