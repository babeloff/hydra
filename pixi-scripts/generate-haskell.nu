#!/usr/bin/env nu
# Generate Haskell kernel files from Hydra DSL modules (Phase 1 sync).
#
# Runs the DSL -> JSON -> Haskell pipeline to regenerate dist/haskell/.
# This is Phase 1 of the full sync and is the prerequisite for regenerating
# any other language target.
#
# Equivalent to: bash heads/haskell/bin/sync-haskell.sh [--no-tests]
#
# Usage (from repo root):
#   pixi run -e haskell generate-haskell

def main [
    --no-tests  # Skip running stack test after generation
] {
    if $no_tests {
        ^bash heads/haskell/bin/sync-haskell.sh --no-tests
    } else {
        ^bash heads/haskell/bin/sync-haskell.sh
    }
}
