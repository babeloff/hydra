#!/usr/bin/env nu

# System GHCi development environment with comprehensive system integration
# This script sets up GHCi with full system compiler and library integration

print "Starting GHCi with comprehensive system integration..."

# Set up comprehensive PATH with ghcup tools first
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin"

# Configure system C/C++ compilers explicitly
$env.CC = "/usr/bin/gcc"
$env.CXX = "/usr/bin/g++"

# Set up comprehensive library paths for full system integration
$env.LD_LIBRARY_PATH = $"($env.CONDA_PREFIX)/lib:/usr/lib64:/lib64"

print "System environment configured:"
print $"  PATH=($env.PATH)"
print $"  CC=($env.CC) (system compiler)"
print $"  CXX=($env.CXX) (system compiler)"
print $"  LD_LIBRARY_PATH=($env.LD_LIBRARY_PATH)"

print ""
print "Launching Stack GHCi with system GHC and full system integration..."

# Launch Stack GHCi with system GHC
^stack ghci --system-ghc

print "System GHCi session ended."
