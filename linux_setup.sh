#!/bin/bash 
# Script to kick-off ansible playbook 
# and setup dev-environment  
sudo apt update 
sudo apt install -y ansible-core python3 python3-pip gh vim

# set vi for bash editing
echo "setting vi as default editor"
set -o vi

# Start Ansible Playbook 
echo "RUNNING PLAYBOOK"
ansible-playbook playbook.yml