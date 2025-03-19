#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

# Define variables
USER=${USER}
HOST=${HOST}

# SSH and wipe files in /home/patrick/homelab, so we start fresh each time with latest changes
ssh $USER@$HOST << EOF
    rm -rf /home/patrick/homelab/*
EOF

# SSH and copy main.tf, /apps, and /monitoring to the remote host
scp main.tf $USER@$HOST:/home/patrick/homelab
scp -r "$(pwd)/apps" $USER@$HOST:/home/patrick/homelab/ 
scp -r "$(pwd)/monitoring" $USER@$HOST:/home/patrick/homelab/ 
scp -r "$(pwd)/network" $USER@$HOST:/home/patrick/homelab/ 

# SSH and run terraform apply -auto-approve
ssh $USER@$HOST << EOF
    cd homelab
    terraform init
    terraform apply -auto-approve
EOF