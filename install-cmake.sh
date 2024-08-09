#!/bin/bash

function error_exit {
    echo "$1" 1>&2
    exit 1
}

CMAKE_LATEST_VERSION=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
if [ -z "$CMAKE_LATEST_VERSION" ]; then
    error_exit "Failed to determine the latest CMake version."
fi

echo "Latest CMake version: $CMAKE_LATEST_VERSION"

CMAKE_TAR="cmake-$CMAKE_LATEST_VERSION-linux-x86_64.tar.gz"
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/$CMAKE_LATEST_VERSION/$CMAKE_TAR"
INSTALL_DIR="$HOME/cmake"

echo "Downloading CMake from $CMAKE_URL..."
curl -L -o "$CMAKE_TAR" "$CMAKE_URL" || error_exit "Failed to download CMake."
echo "Extracting CMake..."
mkdir -p "$INSTALL_DIR" || error_exit "Failed to create install directory."
tar -xzvf "$CMAKE_TAR" -C "$INSTALL_DIR" --strip-components=1 || error_exit "Failed to extract CMake."
rm "$CMAKE_TAR"
echo "Adding CMake to PATH..."
if [[ ":$PATH:" != *":$INSTALL_DIR/bin:"* ]]; then
    echo "export PATH=\$PATH:$INSTALL_DIR/bin" >> "$HOME/.bashrc"
    export PATH=$PATH:$INSTALL_DIR/bin
fi

echo "CMake installation completed. You may need to restart your terminal for the changes to take effect."
echo "source ~/.bashrc"
