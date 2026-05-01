#!/usr/bin/env nu
# Launch GHCi with minimal conda environment interference.
#
# Unsets conda-injected library path variables before starting GHCi so that
# GHC links against its own bundled libraries rather than conda's. Use this
# when the standard ghci-all or ghci-system sessions produce linker errors
# caused by conda library path conflicts.
#
# Usage (from repo root):
#   pixi run -e haskell ghci-minimal

def main [] {
    # Run GHCi in a subshell with conda library paths cleared.
    ^bash -c "unset LD_LIBRARY_PATH LIBRARY_PATH CPATH PKG_CONFIG_PATH; stack ghci --system-ghc hydra:lib"
}
