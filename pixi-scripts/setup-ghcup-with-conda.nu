#!/usr/bin/env nu

# Setup GHC and Stack using ghcup with proper conda environment integration
# This script ensures ghcup-managed tools use conda's libraries and toolchain

# Ensure we're in the right directory
cd ([$env.FILE_PWD] | path dirname)

print "Setting up GHC and Stack via ghcup with conda environment integration..."

# Check if we're in a conda/pixi environment
if ($env.CONDA_PREFIX? | is-empty) {
    print "Error: No conda environment detected. Please run this script with:"
    print "  pixi run -e haskell ./setup-ghcup-with-conda.nu"
    exit 1
}

print $"Using conda environment: ($env.CONDA_PREFIX)"

# Export environment variables for Stack
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

print "Environment variables configured:"
print $"  CC=($env.CC)"
print $"  CONDA_PREFIX=($env.CONDA_PREFIX)"
print $"  LD_LIBRARY_PATH=($env.LD_LIBRARY_PATH)"

# Install GHC and Stack via ghcup
print "Installing GHC 9.10.1 via ghcup..."
^ghcup install ghc 9.10.1
^ghcup set ghc 9.10.1

print "Installing Stack 2.15.7 via ghcup..."
^ghcup install stack 2.15.7
^ghcup set stack 2.15.7

# Clean any previous problematic builds
print "Cleaning previous builds..."
if (which stack | is-not-empty) {
    do { ^stack clean --full } | complete | ignore
}

let cleanup_dirs = [".stack-work", "hydra-haskell/.stack-work", "hydra-ext/.stack-work"]
for dir in $cleanup_dirs {
    if ($dir | path exists) {
        rm -rf $dir
    }
}

# Verify conda libraries are available
print "Verifying conda libraries..."
let libgmp_path = $"($env.CONDA_PREFIX)/lib/libgmp.so"
if not ($libgmp_path | path exists) {
    print "Error: libgmp not found in conda environment"
    print "Run: pixi install -e haskell"
    exit 1
}

print "Found required libraries:"
ls $"($env.CONDA_PREFIX)/lib/libgmp.so*" | ignore
ls $"($env.CONDA_PREFIX)/lib/libz.so*" | ignore
ls $"($env.CONDA_PREFIX)/lib/libffi.so*" | ignore

# Verify ghcup installations
print "Verifying ghcup installations..."
print $"GHC version: (^ghc --version)"
print $"Stack version: (^stack --version)"

# Try Stack setup with system GHC (from ghcup)
print "Setting up Stack to use system GHC from ghcup..."
print "This should be quick since GHC is already installed..."

# Run stack setup with system GHC
^stack setup --system-ghc

print "GHC and Stack setup via ghcup completed!"
print ""
print "You can now run:"
print "  pixi run -e haskell stack ghci --system-ghc"
print "  pixi run -e haskell stack build --system-ghc"
print ""
print "Or use the pixi tasks:"
print "  pixi run -e haskell stack-ghci"
print "  pixi run -e haskell stack-build"
