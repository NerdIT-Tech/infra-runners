FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform ecosystem tools
RUN curl -sSLo /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip \
    && unzip /tmp/tflint.zip -d /usr/local/bin \
    && rm /tmp/tflint.zip \
    && curl -sSLo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz \
    && tar -xzf /tmp/terraform-docs.tar.gz -C /usr/local/bin \
    && rm /tmp/terraform-docs.tar.gz \
    && curl -sSLo /tmp/tfsec https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 \
    && chmod +x /tmp/tfsec \
    && mv /tmp/tfsec /usr/local/bin/

# Install Ansible and Ansible-lint
RUN pip3 install --no-cache-dir \
    ansible==9.5.1 \
    ansible-lint==24.7.0 \
    molecule

# Install Just
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*

USER vscode
