#!/bin/sh
mkdir -p ./secrets/sshd
yes 'y' | ssh-keygen -N '' -f ./secrets/sshd/ssh_host_rsa_key -t rsa -C headnode
yes 'y' | ssh-keygen -N '' -f ./secrets/sshd/ssh_host_ecdsa_key -t ecdsa -C headnode
yes 'y' | ssh-keygen -N '' -f ./secrets/sshd/ssh_host_ed25519_key -t ed25519 -C headnode
chmod 600 ./secrets/sshd/ssh_host_*_key
