#!/bin/bash
# Run Stack GHCi using ghcup-managed tools with conda environment integration
# This script ensures GHCi uses conda's libraries and both hydra packages

set -e

echo "Starting Stack GHCi (ghcup-managed) with conda environment integration..."

# Ensure we're in the right directory
cd "$(dirname "$0")"

# Check if we're in a conda/pixi environment
if [[ -z "$CONDA_PREFIX" ]]; then
    echo "Error: No conda environment detected. Please run this script with:"
    echo "  pixi run -e haskell ./run-stack-ghci.sh"
    exit 1
fi

echo "Using conda environment: $CONDA_PREFIX"

# Export environment variables for Stack/GHCi
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

# Set ghcup environment
export GHCUP_INSTALL_BASE_PREFIX="$CONDA_PREFIX"

# Verify ghcup tools are available
if ! command -v stack >/dev/null 2>&1; then
    echo "Stack not found. Please run setup first:"
    echo "  pixi run -e haskell ./setup-ghcup-with-conda.sh"
    exit 1
fi

if ! command -v ghc >/dev/null 2>&1; then
    echo "GHC not found. Please run setup first:"
    echo "  pixi run -e haskell ./setup-ghcup-with-conda.sh"
    exit 1
fi

echo "Using GHC: $(ghc --version)"
echo "Using Stack: $(stack --version)"

echo "Starting GHCi with both hydra and hydra-ext packages..."
echo "Environment configured for conda integration"
echo ""
echo "In GHCi, you can:"
echo "  :l Hydra.Core.Model              -- Load core Hydra modules"
echo "  :l Hydra.Ext.Java.Language       -- Load extension modules"
echo "  :browse Hydra.Core.Model         -- Browse available functions"
echo "  :type someFunction               -- Check function types"
echo "  :reload                          -- Reload after code changes"
echo ""

# Run Stack GHCi with system GHC (from ghcup)
stack ghci --system-ghc

echo "GHCi session ended."
