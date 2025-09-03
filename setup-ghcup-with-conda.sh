#!/bin/bash
# Setup GHC and Stack using ghcup with proper conda environment integration
# This script ensures ghcup-managed tools use conda's libraries and toolchain

set -e

echo "Setting up GHC and Stack via ghcup with conda environment integration..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check if we're in a conda/pixi environment
if [[ -z "$CONDA_PREFIX" ]]; then
    echo "Error: No conda environment detected. Please run this script with:"
    echo "  pixi run -e haskell ./setup-ghcup-with-conda.sh"
    exit 1
fi

echo "Using conda environment: $CONDA_PREFIX"

# Export environment variables for Stack
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:${LD_LIBRARY_PATH:-}"
export LIBRARY_PATH="$CONDA_PREFIX/lib:${LIBRARY_PATH:-}"
export CPATH="$CONDA_PREFIX/include:${CPATH:-}"
export PKG_CONFIG_PATH="$CONDA_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
export C_INCLUDE_PATH="$CONDA_PREFIX/include:${C_INCLUDE_PATH:-}"
export CPLUS_INCLUDE_PATH="$CONDA_PREFIX/include:${CPLUS_INCLUDE_PATH:-}"

# Force GCC and linker to use conda environment
export CC="$CONDA_PREFIX/bin/gcc"
export CXX="$CONDA_PREFIX/bin/g++"
export CPP="$CONDA_PREFIX/bin/cpp"
export LD="$CONDA_PREFIX/bin/ld"

# Configure GHC build options to use conda libraries
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"

echo "Environment variables configured:"
echo "  CC=$CC"
echo "  CONDA_PREFIX=$CONDA_PREFIX"
echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

# Install GHC and Stack via ghcup
echo "Installing GHC 9.10.1 via ghcup..."
ghcup install ghc 9.10.1
ghcup set ghc 9.10.1

echo "Installing Stack 2.15.7 via ghcup..."
ghcup install stack 2.15.7
ghcup set stack 2.15.7

# Clean any previous problematic builds
echo "Cleaning previous builds..."
if command -v stack >/dev/null 2>&1; then
    stack clean --full 2>/dev/null || true
fi
rm -rf .stack-work hydra-haskell/.stack-work hydra-ext/.stack-work 2>/dev/null || true

# Verify conda libraries are available
echo "Verifying conda libraries..."
if [[ ! -f "$CONDA_PREFIX/lib/libgmp.so" ]]; then
    echo "Error: libgmp not found in conda environment"
    echo "Run: pixi install -e haskell"
    exit 1
fi

echo "Found required libraries:"
ls -la "$CONDA_PREFIX/lib/libgmp.so"* || true
ls -la "$CONDA_PREFIX/lib/libz.so"* || true
ls -la "$CONDA_PREFIX/lib/libffi.so"* || true

# Verify ghcup installations
echo "Verifying ghcup installations..."
echo "GHC version: $(ghc --version)"
echo "Stack version: $(stack --version)"

# Try Stack setup with system GHC (from ghcup)
echo "Setting up Stack to use system GHC from ghcup..."
echo "This should be quick since GHC is already installed..."

# Run stack setup with system GHC
stack setup --system-ghc

echo "GHC and Stack setup via ghcup completed!"
echo ""
echo "You can now run:"
echo "  pixi run -e haskell stack ghci --system-ghc"
echo "  pixi run -e haskell stack build --system-ghc"
echo ""
echo "Or use the pixi tasks:"
echo "  pixi run -e haskell stack-ghci"
echo "  pixi run -e haskell stack-build"
