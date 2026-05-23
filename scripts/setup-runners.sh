#!/bin/bash
set -e

# Load local secrets if they exist
if [ -f .env ]; then
  echo "Loading secrets from .env..."
  # Cleanly source the file and export everything
  set -a
  source .env
  set +a
  
  # Ensure all TF_VARs are explicitly exported for the current shell
  export $(grep '^TF_VAR_' .env | cut -d= -f1)
  export GH_PAT GH_ORG
fi

# 1. Terraform
echo "Applying Terraform..."
cd terraform
terraform init -input=false
terraform apply -auto-approve -input=false

# 2. Extract IPs from Terraform Output
# Terraform now captures DHCP IPs via qemu-guest-agent
RUNNER_IPS=$(terraform output -json runner_ips | jq -r 'to_entries[] | "\(.key) ansible_host=\(.value)"')

echo "Generated Inventory:"
echo "[github_runners]"
echo "$RUNNER_IPS"

# 3. Ansible
echo "Running Ansible..."
cd ../ansible
# Create a temporary inventory
echo "[github_runners]" > temporary_hosts.ini
echo "$RUNNER_IPS" >> temporary_hosts.ini
echo "" >> temporary_hosts.ini
echo "[github_runners:vars]" >> temporary_hosts.ini
echo "ansible_user=runner" >> temporary_hosts.ini

# Write the private key to a temporary file for Ansible to use
echo "$TF_VAR_ssh_private_key" > runner_key
chmod 600 runner_key

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i temporary_hosts.ini site.yml \
  --private-key runner_key \
  --extra-vars "GH_PAT=$GH_PAT GH_ORG=$GH_ORG"

rm runner_key
