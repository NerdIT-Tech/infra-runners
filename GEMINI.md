# On-Prem GitHub Runners on Proxmox

This project provides Infrastructure as Code (IaC) to deploy and manage self-hosted GitHub Actions runners on a Proxmox VE cluster.

## Architecture

1.  **Terraform**: Provisions Virtual Machines on Proxmox using a Cloud-Init template.
    *   `terraform/`: Main configuration and provider setup.
    *   `terraform/modules/proxmox-runner`: Reusable module for VM creation.
2.  **Ansible**: Configures the VMs and registers them as GitHub Runners.
    *   `ansible/roles/common`: Basic OS hardening and utilities.
    *   `ansible/roles/docker`: Installs Docker (required for many CI tasks).
    *   `ansible/roles/github-runner`: Downloads, installs, and registers the GitHub Actions runner service.

## Prerequisites

- Proxmox VE cluster with API access.
- A Cloud-Init Ubuntu template (e.g., `tmpl-ubuntu-22.04-ci`).
- GitHub Personal Access Token (PAT) with `admin:org_runner` or `repo` scope.
- SSH key for VM access.

## CI/CD Workflow

The project includes a GitHub Actions workflow (`.github/workflows/deploy-runners.yml`) designed to run on a **self-hosted runner** with access to your Proxmox API.

### Workflow Stages

1.  **Validate**: Runs on every Pull Request. Performs `terraform fmt`, `validate`, and `plan`.
2.  **Deploy**: Runs only on merges to `main`. Executes `terraform apply` and the Ansible configuration playbook.

### Required GitHub Secrets

| Secret | Description |
| :--- | :--- |
| `PROXMOX_API_URL` | Proxmox API endpoint (e.g., `https://pve.local:8006/api2/json`) |
| `PROXMOX_USER` | API Username (e.g., `root@pam`) |
| `PROXMOX_PASSWORD` | API Password/Token |
| `SSH_PUBLIC_KEY` | Public key for Cloud-Init |
| `SSH_PRIVATE_KEY` | Private key for Ansible/Provisioning |
| `GH_RUNNER_PAT` | GitHub PAT with `admin:org_runner` scope |
| `GH_ORG` | Your GitHub Organization name |

## Security Considerations

- **Secrets**: The GitHub PAT should never be committed. Use Ansible Vault or environment variables.
- **Isolation**: Runners are placed in a dedicated Proxmox pool and can be segmented via VLANs in the Proxmox network configuration.
- **Updates**: Use Ansible to periodically update the runner version and OS packages.

## Scalability

To add more runners, simply update the `runners` map in `terraform/main.tf` and re-run the deployment.
