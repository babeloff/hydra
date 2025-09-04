#!/usr/bin/env nu

# Minimal GHCi environment with reduced conda interference
# This script provides a lightweight GHCi setup with minimal environment changes

print "Starting minimal GHCi with reduced conda interference..."

# Set up minimal PATH with ghcup tools and essential system paths
$env.PATH = $"($env.CONDA_PREFIX)/.ghcup/bin:/usr/bin:/bin:/usr/local/bin"

print "Minimal environment configured:"
print $"  PATH=($env.PATH)"

print ""
print "Launching Stack GHCi with minimal conda interference..."

# Launch Stack GHCi with system GHC
exec stack ghci --system-ghc
