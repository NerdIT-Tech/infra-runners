# SRE Optimized GitHub Actions Runner (Podman-native)
FROM fedora:40

# 1. Install core dependencies
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
    dnf-plugins-core \
    && dnf clean all

# 2. Install Terraform
# We use the RHEL repository and hardcode the version to 9 as Fedora 40/39 specific repos are sometimes missing.
# We use /etc/yum.repos.d as it is the standard path in Fedora/RHEL.
RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
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
