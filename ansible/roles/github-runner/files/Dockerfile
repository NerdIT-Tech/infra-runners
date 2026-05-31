# SRE Optimized GitHub Actions Runner (Podman-native)
FROM fedora:latest

# 1. Install core dependencies
# DNF5 is the new standard in Fedora 41+
RUN dnf install -y \
    curl \
    git \
    jq \
    unzip \
    tar \
    python3-pip \
    python3-devel \
    gcc \
    libffi-devel \
    openssl-devel \
    gettext \
    ansible \
    procps-ng \
    && dnf clean all

# 2. Install Terraform
# We use the RHEL repository and hardcode the version to 9 as Fedora-specific repos are often missing for new releases.
# DNF5 uses 'addrepo --from-repofile' instead of '--add-repo'.
RUN dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    sed -i 's/\$releasever/9/g' /etc/yum.repos.d/hashicorp.repo && \
    dnf install -y terraform && \
    dnf clean all

# 3. Create runner user
RUN useradd -m runner

# 4. Download and install GitHub Runner
ARG RUNNER_VERSION="2.316.1"
WORKDIR /home/runner/actions-runner
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && ./bin/installdependencies.sh

# 5. Setup entrypoint script
COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh && chown -R runner:runner /home/runner

USER runner
ENTRYPOINT ["/home/runner/entrypoint.sh"]
