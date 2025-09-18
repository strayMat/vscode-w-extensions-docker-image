#!/bin/bash
set -e

# Number of retries
retries=3
# Wait time between retries
wait_time=10

# Function to install an extension with retries
install_extension() {
    local extension=$1
    local attempt=1

    while [ $attempt -le $retries ]; do
        code-server --install-extension $extension && break
        echo "Failed to install $extension. Attempt $attempt/$retries. Retrying in $wait_time seconds..."
        attempt=$((attempt + 1))
        sleep $wait_time
    done

    if [ $attempt -gt $retries ]; then
        echo "Failed to install $extension after $retries attempts."
        exit 1
    fi
}

# Install custom extensions
base_extensions=(
    "charliermarsh.ruff"
    "GrapeCity.gc-excelviewer"
    "mechatroner.rainbow-csv"
)
for extension in "${base_extensions[@]}"; do
    install_extension $extension
done
