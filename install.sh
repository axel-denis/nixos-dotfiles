#!/bin/sh

# Argument validation
if [ $# -ne 1 ]; then
    echo "Usage: $0 [laptop|server]"
    exit 1
fi
if [ "$1" != "laptop" ] && [ "$1" != "server" ]; then
    echo "Error: Invalid argument. Must be 'laptop' or 'server'"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
REPO_URL="https://github.com/axel-denis/nixos-dotfiles.git"

echo "Cloning repository..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" || exit 1

SOURCE_DIR="$TEMP_DIR/$1"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR not found"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Copying files to /etc/nixos..."
sudo cp "/etc/nixos/hardware-configuration.nix" "$SOURCE_DIR"/
sudo rm -rf "/etc/nixos/"
sudo mkdir "/etc/nixos"
sudo cp -rf "$SOURCE_DIR"/* /etc/nixos/ || {
    echo "Error: Failed to copy files"
    rm -rf "$TEMP_DIR"
    exit 1
}

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Configuration added successfully!"
sudo nixos-rebuild switch
