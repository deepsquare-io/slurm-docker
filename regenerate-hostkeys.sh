#!/bin/sh
mkdir -p ./secrets/hostkeys
yes 'y' | ssh-keygen -N '' -f ./secrets/hostkeys/ssh_host_rsa_key -t rsa -C headnode
yes 'y' | ssh-keygen -N '' -f ./secrets/hostkeys/ssh_host_ecdsa_key -t ecdsa -C headnode
yes 'y' | ssh-keygen -N '' -f ./secrets/hostkeys/ssh_host_ed25519_key -t ed25519 -C headnode
chmod 600 ./hostkeys/ssh_host_*_key
