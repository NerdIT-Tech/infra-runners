#!/bin/bash
set -e

# Configuration
RUNNER_NAME=${RUNNER_NAME:-$(hostname)}
GITHUB_URL=${GITHUB_URL}
GITHUB_TOKEN=${GITHUB_TOKEN}
LABELS=${LABELS:-""}

if [ -z "$GITHUB_URL" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_URL and GITHUB_TOKEN must be set."
    exit 1
fi

# Cleanup on exit
cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token "${GITHUB_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Configure the runner
./config.sh \
    --url "${GITHUB_URL}" \
    --token "${GITHUB_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${LABELS}" \
    --unattended \
    --replace \
    --ephemeral

# Start the runner
./run.sh & wait $!
