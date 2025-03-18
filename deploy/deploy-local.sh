#!/bin/bash

# Variables
REMOTE_USER="patrick"
REMOTE_HOST="192.168.86.87"
REMOTE_DIR="/home/patrick/homelab"
LOG_FILE="deploy.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# SSH into homelab machine and copy files
log "Starting file transfer to $REMOTE_HOST"
scp ../main.tf $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR 2>&1 | tee -a $LOG_FILE
scp -r ../monitoring $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR 2>&1 | tee -a $LOG_FILE
scp -r ../apps $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR 2>&1 | tee -a $LOG_FILE

# Run terraform apply
log "Running terraform apply on $REMOTE_HOST"
ssh $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_DIR && terraform apply -auto-approve" 2>&1 | tee -a $LOG_FILE

log "Deployment completed"