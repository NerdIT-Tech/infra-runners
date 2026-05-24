#!/bin/bash
set -e

# SRE Manual Bootstrap Script
# Use this to stand up the VERY FIRST runner manually from your local machine.

echo "--- Proxmox GitHub Runner Bootstrap ---"

# 1. Ensure Environment Variables are set
if [[ -z "$PROXMOX_API_URL" || -z "$PROXMOX_USER" || -z "$PROXMOX_PASSWORD" || -z "$GH_PAT" || -z "$GH_ORG" ]]; then
    echo "Error: Missing environment variables."
    echo "Please export: PROXMOX_API_URL, PROXMOX_USER, PROXMOX_PASSWORD, GH_PAT, GH_ORG"
    exit 1
fi

# 2. Terraform Provisioning
echo "Step 1: Provisioning VM via Terraform..."
cd terraform

# Initialize with local state for bootstrap if DB isn't ready, 
# but usually we assume the DB is ready from the 'bootstrap/db' step.
terraform init -reconfigure

# Target ONLY the first runner to keep it simple
RUNNER_NAME="gh-runner-01"
echo "Targeting $RUNNER_NAME..."

terraform apply -auto-approve \
    -var="pm_api_url=$PROXMOX_API_URL" \
    -var="pm_user=$PROXMOX_USER" \
    -var="pm_password=$PROXMOX_PASSWORD" \
    -target=module.gh_runners[\"$RUNNER_NAME\"]

# Get the IP
RUNNER_IP=$(terraform output -json runner_ips | jq -r ".\"$RUNNER_NAME\"")

RUNNER_IP="192.168.1.159"

if [[ -z "$RUNNER_IP" || "$RUNNER_IP" == "null" ]]; then
    echo "Error: Could not retrieve IP for $RUNNER_NAME. Is the VM up and got a DHCP lease?"
    exit 1
fi

echo "VM is up at $RUNNER_IP"

# 3. Ansible Configuration
echo "Step 2: Configuring Runner via Ansible..."
cd ../ansible

# Create temporary inventory
cat <<EOT > bootstrap_hosts.ini
[github_runners]
$RUNNER_NAME ansible_host=$RUNNER_IP

[github_runners:vars]
ansible_user=runner
EOT

# Wait for SSH to be ready
echo "Waiting for SSH to become available on $RUNNER_IP..."
max_retries=30
count=0
# Use bash-native /dev/tcp check to avoid 'nc' dependency
until timeout 1 bash -c "cat < /dev/null > /dev/tcp/$RUNNER_IP/22" 2>/dev/null; do
  ((count++))
  if [ $count -ge $max_retries ]; then
    echo "Error: SSH did not become available after $max_retries attempts."
    exit 1
  fi
  echo -n "."
  sleep 2
done
echo " SSH is ready!"

# Write the private key to a temporary file for Ansible to use
echo "$TF_VAR_ssh_private_key" > runner_key
chmod 600 runner_key

# Run the playbook
# Note: Ensure you have your SSH private key available locally
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i bootstrap_hosts.ini site.yml \
    --private-key runner_key \
    --extra-vars "GH_PAT=$GH_PAT GH_ORG=$GH_ORG"

echo "----------------------------------------"
echo "SUCCESS: $RUNNER_NAME is now online and registered to $GH_ORG"
echo "You can now run your GitHub Actions workflows!"
