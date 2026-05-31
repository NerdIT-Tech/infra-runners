# SRE Optimized GitHub Actions Runner (Podman-native)
FROM fedora:39

# 1. Install core dependencies
# We use Fedora for better Podman support and newer packages
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
RUN mkdir -p /etc/dnf.repos.d && \
    curl -fsSL https://rpm.releases.hashicorp.com/fedora/hashicorp.repo -o /etc/dnf.repos.d/hashicorp.repo \
    && dnf install -y terraform \
    && dnf clean all

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
