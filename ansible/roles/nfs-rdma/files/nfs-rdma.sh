#!/bin/bash
set -euo pipefail

echo "Starting VAST NFS package installation..."

# Step 0: Create a safe working directory in /tmp
TIMESTAMP=$(date +%s)
WORK_DIR="/tmp/vastnfs-${TIMESTAMP}"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
echo "Working in temporary directory: $WORK_DIR"

# Step 1: Download the VAST NFS package
echo "1. Downloading the VAST NFS package..."
if ! curl -sSf https://vast-nfs.s3.amazonaws.com/download.sh | bash -s --; then
    echo "Error: Failed to download the VAST NFS package."
    exit 1
fi
echo "VAST NFS package download script executed successfully."

# Step 1.1: Identify and extract the downloaded tarball
echo "1.1. Identifying and extracting the downloaded tarball..."
TARBALL=$(find . -maxdepth 1 -name "vastnfs-*.tar.xz" | head -n 1)

if [ -z "$TARBALL" ]; then
    echo "Error: No 'vastnfs-*.tar.xz' file found after running download.sh."
    exit 1
fi

echo "Found tarball: $TARBALL"
if ! tar -xf "$TARBALL"; then
    echo "Error: Failed to extract tarball '$TARBALL'."
    exit 1
fi
echo "Tarball extracted successfully."

# Step 1.2: Change into the extracted directory
EXTRACTED_DIR=$(basename "$TARBALL" .tar.xz)
if [ ! -d "$EXTRACTED_DIR" ]; then
    echo "Error: Extracted directory '$EXTRACTED_DIR' not found."
    exit 1
fi

cd "$EXTRACTED_DIR"
echo "Changed into '$EXTRACTED_DIR' successfully."

# Step 2: Build the package
echo "2. Building the package..."
if [ ! -f "build.sh" ]; then
    echo "Error: build.sh not found in the current directory."
    exit 1
fi
chmod +x build.sh
if ! ./build.sh bin; then
    echo "Error: Failed to build the VAST NFS package."
    exit 1
fi
echo "VAST NFS package built successfully."

# Step 3: Install the package using dpkg
echo "3. Installing the package..."
deb_file=$(find ./dist -name "vastnfs-dkms_*.deb" | head -n 1)
if [ -z "$deb_file" ]; then
    echo "Error: .deb package not found in ./dist/"
    exit 1
fi

echo "Found package: $deb_file"
if ! sudo dpkg -i "$deb_file"; then
    echo "Error: Failed to install the VAST NFS package with dpkg."
    exit 1
fi
echo "VAST NFS package installed successfully."

# Step 4: Update initramfs
echo "4. Updating initramfs..."
if ! sudo update-initramfs -u -k "$(uname -r)"; then
    echo "Error: Failed to update initramfs."
    exit 1
fi
echo "Initramfs updated successfully."

echo "VAST NFS package installation complete."
