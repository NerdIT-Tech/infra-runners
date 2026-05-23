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

## SRE & High Availability Design

This infrastructure has been reimagined for maximum resilience and high availability:

-   **Node Spreading**: Runners are automatically distributed across the Proxmox cluster (`var.proxmox_nodes`) using modulo logic to avoid single points of failure.
-   **Zero-Downtime Updates**: Uses `create_before_destroy` lifecycle policy. Terraform will provision a replacement runner before destroying an old one, ensuring capacity is maintained.
-   **Safety Interlocks**:
    -   **Variable Validation**: `runner_count` must be $\ge 1$.
    -   **Terraform Checks**: A `check` block validates that the plan maintains at least one runner.
    -   **Orchestration Guardrails**: The `setup-runners.sh` script will abort if it detects zero runners in the state.
-   **Performance Tuning**: VMs use `host` CPU types for optimized virtualization performance and fixed memory to prevent CI job instability due to ballooning.
-   **Observability**: VMs are tagged in Proxmox with `gh-runner` and `terraform` for easier management.

## Scalability

To scale the runner fleet, simply update the `runner_count` variable in `terraform/variables.tf` (or via `-var="runner_count=5"`). The infrastructure will automatically distribute new instances across your Proxmox cluster.
