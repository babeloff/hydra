#!/usr/bin/env nu

# Combined GHCi development environment with full system integration
# This script sets up a comprehensive environment for Haskell development

print "Starting GHCi with full system integration..."

# Set up comprehensive PATH
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin"

# Configure C/C++ compilers
$env.CC = "/usr/bin/gcc"
$env.CXX = "/usr/bin/g++"

# Set up library paths for conda integration
$env.LD_LIBRARY_PATH = $"($env.CONDA_PREFIX)/lib:/usr/lib64:/lib64"

print "Environment configured:"
print $"  PATH=($env.PATH)"
print $"  CC=($env.CC)"
print $"  CXX=($env.CXX)"
print $"  LD_LIBRARY_PATH=($env.LD_LIBRARY_PATH)"

print ""
print "Launching Stack GHCi with system GHC..."

# Launch Stack GHCi
^stack ghci --system-ghc

print "GHCi session ended."
