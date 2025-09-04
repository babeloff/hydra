#!/usr/bin/env nu

# Fixed GHCi development environment with corrected library path ordering
# This script provides a stable GHCi environment with proper conda integration

print "Starting GHCi with fixed library path ordering..."

# Set up library paths with conda first (corrected ordering)
$env.LD_LIBRARY_PATH = $"($env.CONDA_PREFIX)/lib:/usr/lib64:/lib64"

# Set up PATH with ghcup tools
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin"

print "Environment configured with fixed library ordering:"
print $"  LD_LIBRARY_PATH=($env.LD_LIBRARY_PATH)"
print $"  PATH=($env.PATH)"

print ""
print "Launching Stack GHCi with system GHC..."

# Launch Stack GHCi
^stack ghci --system-ghc

print "GHCi session ended."
