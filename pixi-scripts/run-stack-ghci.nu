#!/usr/bin/env nu

# Run Stack GHCi using ghcup-managed tools with conda environment integration
# This script ensures GHCi uses conda's libraries and both hydra packages

# Ensure we're in the right directory
cd ([$env.FILE_PWD] | path dirname)

print "Starting Stack GHCi (ghcup-managed) with conda environment integration..."

# Check if we're in a conda/pixi environment
if ($env.CONDA_PREFIX? | is-empty) {
    print "Error: No conda environment detected. Please run this script with:"
    print "  pixi run -e haskell ./run-stack-ghci.nu"
    exit 1
}

print $"Using conda environment: ($env.CONDA_PREFIX)"

# Export environment variables for Stack/GHCi
$env.LD_LIBRARY_PATH = $"($env.CONDA_PREFIX)/lib:($env.LD_LIBRARY_PATH? | default '')"
$env.LIBRARY_PATH = $"($env.CONDA_PREFIX)/lib:($env.LIBRARY_PATH? | default '')"
$env.CPATH = $"($env.CONDA_PREFIX)/include:($env.CPATH? | default '')"
$env.PKG_CONFIG_PATH = $"($env.CONDA_PREFIX)/lib/pkgconfig:($env.PKG_CONFIG_PATH? | default '')"
$env.C_INCLUDE_PATH = $"($env.CONDA_PREFIX)/include:($env.C_INCLUDE_PATH? | default '')"
$env.CPLUS_INCLUDE_PATH = $"($env.CONDA_PREFIX)/include:($env.CPLUS_INCLUDE_PATH? | default '')"

# Force GCC and linker to use conda environment
$env.CC = $"($env.CONDA_PREFIX)/bin/gcc"
$env.CXX = $"($env.CONDA_PREFIX)/bin/g++"
$env.CPP = $"($env.CONDA_PREFIX)/bin/cpp"
$env.LD = $"($env.CONDA_PREFIX)/bin/ld"

# Configure GHC build options to use conda libraries
$env.LDFLAGS = $"-L($env.CONDA_PREFIX)/lib -Wl,-rpath,($env.CONDA_PREFIX)/lib"
$env.CPPFLAGS = $"-I($env.CONDA_PREFIX)/include"
$env.CFLAGS = $"-I($env.CONDA_PREFIX)/include"
$env.CXXFLAGS = $"-I($env.CONDA_PREFIX)/include"

# Set ghcup environment
$env.GHCUP_INSTALL_BASE_PREFIX = $env.CONDA_PREFIX

# Verify ghcup tools are available
if not (which stack | is-not-empty) {
    print "Stack not found. Please run setup first:"
    print "  pixi run -e haskell ./setup-ghcup-with-conda.nu"
    exit 1
}

if not (which ghc | is-not-empty) {
    print "GHC not found. Please run setup first:"
    print "  pixi run -e haskell ./setup-ghcup-with-conda.nu"
    exit 1
}

print $"Using GHC: (ghc --version)"
print $"Using Stack: (stack --version)"

print "Starting GHCi with both hydra and hydra-ext packages..."
print "Environment configured for conda integration"
print ""
print "In GHCi, you can:"
print "  :l Hydra.Core.Model              -- Load core Hydra modules"
print "  :l Hydra.Ext.Java.Language       -- Load extension modules"
print "  :browse Hydra.Core.Model         -- Browse available functions"
print "  :type someFunction               -- Check function types"
print "  :reload                          -- Reload after code changes"
print ""

# Run Stack GHCi with system GHC (from ghcup)
^stack ghci --system-ghc

print "GHCi session ended."
