#!/bin/bash
# Install system dependencies for Haskell development on Fedora/RHEL

echo "Installing Haskell development dependencies..."

sudo dnf install -y \
    gmp-devel \
    zlib-devel \
    ncurses-devel \
    libffi-devel \
    make \
    gcc \
    gcc-c++ \
    pkgconf-pkg-config \
    libnuma-devel \
    tinfo

echo "System dependencies installed successfully!"
echo ""
echo "You can now run:"
echo "  chmod +x install-haskell-deps.sh"
echo "  ./install-haskell-deps.sh"
echo "  stack ghci"
