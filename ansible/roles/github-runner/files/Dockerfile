# SRE Optimized GitHub Actions Runner (Podman-native)
FROM fedora:40

# Configure DNF and Install all dependencies in a single layer to reduce commit overhead
RUN echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf && \
    echo "fastestmirror=True" >> /etc/dnf/dnf.conf && \
    dnf install -y \
    curl git jq unzip tar python3-pip python3-devel gcc libffi-devel openssl-devel gettext ansible procps-ng dnf-plugins-core && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    sed -i 's/\$releasever/9/g' /etc/yum.repos.d/hashicorp.repo && \
    dnf install -y terraform && \
    dnf clean all

RUN useradd -m runner

ARG RUNNER_VERSION="2.316.1"
WORKDIR /home/runner/actions-runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner.tar.gz && \
    rm ./actions-runner.tar.gz && \
    ./bin/installdependencies.sh

COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh && chown -R runner:runner /home/runner

USER runner
ENTRYPOINT ["/home/runner/entrypoint.sh"]
