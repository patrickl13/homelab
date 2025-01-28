#!/bin/bash
if ! command -v ansible &> /dev/null
then
    echo "Ansible not found, installing..."
    sudo apt update
    sudo apt install -y ansible
else
    echo "Ansible is already installed"
fi