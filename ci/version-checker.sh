#!/bin/sh
set -ex

slurm_version=$(curl --silent https://api.github.com/repos/schedmd/slurm/tags | jq '.[1].name' | awk '{ print substr( $0, 2, length($0)-2 ) }')
slurm_tag=$(curl --silent https://api.github.com/repos/schedmd/slurm/tags | jq -r '.[1].name')
META="$(curl -fsSL "https://raw.githubusercontent.com/SchedMD/slurm/${slurm_tag}/META")"
slurm_version=$(echo "${META}" | grep 'Version:' | sed -E 's/.*Version:\t+(.*)/\1/g')
slurm_release=$(echo "${META}" | grep 'Release:' | sed -E 's/.*Release:\t+(.*)/\1/g')
slurm_definitive_version="${slurm_version}-${slurm_release}"
sed -i "s/slurm_version=.*\$/slurm_version=${slurm_definitive_version}/g" ./slurm/Dockerfile.rocky8.6
sed -i "s/slurm_version=.*\$/slurm_version=${slurm_definitive_version}/g" ./slurm/Dockerfile.rocky9.0
sed -i "s/slurm_version=.*\$/slurm_version=${slurm_definitive_version}/g" ./slurm/build-all.rocky8.6.sh
sed -i "s/slurm_version=.*\$/slurm_version=${slurm_definitive_version}/g" ./slurm/build-all.rocky9.0.sh
