# SRE Optimized GitHub Actions Runner (Podman-native)
FROM fedora:45

RUN sudo rpm --import https://apt.releases.hashicorp.com/gpg

RUN sudo tee /etc/dnf.repos.d/hashicorp.repo <<EOF
[hashicorp]
name=HashiCorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://apt.releases.hashicorp.com/gpg
EOF
    
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
    terrform \
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
