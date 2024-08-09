#!/bin/bash

MIN_CMAKE_VERSION="3.12"

function version_greater_equal() {
    printf '%s\n%s\n' "$1" "$2" | sort -V -C
}

CURRENT_CMAKE_VERSION=$(cmake --version 2>/dev/null | head -n 1 | awk '{print $3}')

if [ -z "$CURRENT_CMAKE_VERSION" ]; then
    echo "CMake not found. Installing the latest version..."
    ./install_cmake.sh
else
    echo "Current CMake version: $CURRENT_CMAKE_VERSION"
    if ! version_greater_equal "$CURRENT_CMAKE_VERSION" "$MIN_CMAKE_VERSION"; then
        echo "CMake version is less than $MIN_CMAKE_VERSION. Installing the latest version..."
        ./install_cmake.sh
    else
        echo "CMake version is sufficient."
    fi
fi

echo "Configuring the project..."
cmake -S src -B build -DUSE_SYSTEM_PCAP=OFF
echo "Building the project..."
cmake --build build -t ppwn
if [ -f "build/ppwn" ]; then
    echo "Copying ppwn to the root project directory..."
    cp build/ppwn ./
    echo "ppwn copied successfully."
else
    echo "Error: ppwn not found in the build directory."
    exit 1
fi

echo "Build completed successfully."
