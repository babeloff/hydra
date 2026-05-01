#!/usr/bin/env nu
# Build (sync/regenerate) the Hydra Scala implementation.
#
# Regenerates dist/scala/ from Haskell DSL sources by running the full
# Scala sync pipeline: DSL -> JSON -> Scala kernel + coders + tests.
#
# Equivalent to: bash bin/sync-scala.sh [--no-tests]
#
# Usage (from repo root):
#   nu pixi-scripts/build-scala.nu
#   nu pixi-scripts/build-scala.nu --no-tests

def main [
    --no-tests  # Skip running sbt tests after generation
] {
    if $no_tests {
        ^bash bin/sync-scala.sh --no-tests
    } else {
        ^bash bin/sync-scala.sh
    }
}
