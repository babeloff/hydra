#!/usr/bin/env nu
# Build (sync/regenerate) the Hydra Haskell implementation.
#
# Runs Phase 1 of the sync pipeline: DSL -> JSON + Haskell kernel regeneration.
# This is the bootstrapping step that must succeed before any other language
# can be regenerated.
#
# Equivalent to: bash heads/haskell/bin/sync-haskell.sh [--no-tests]
#
# Usage (from repo root):
#   nu pixi-scripts/build-haskell.nu
#   nu pixi-scripts/build-haskell.nu --no-tests

def main [
    --no-tests  # Skip running stack test after generation
] {
    if $no_tests {
        ^bash heads/haskell/bin/sync-haskell.sh --no-tests
    } else {
        ^bash heads/haskell/bin/sync-haskell.sh
    }
}
