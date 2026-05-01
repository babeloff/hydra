#!/usr/bin/env nu
# Generate Java source files from Hydra DSL modules.
#
# Runs the full Java sync pipeline (Phase 1 Haskell + Phase 3 Java kernel
# + Phase 4 cross-host coders) to regenerate dist/java/.
#
# Equivalent to: bash bin/sync-java.sh [--no-tests]
#
# Usage (from repo root):
#   pixi run -e haskell generate-java

def main [
    --no-tests  # Skip running Gradle tests after generation
] {
    if $no_tests {
        ^bash bin/sync-java.sh --no-tests
    } else {
        ^bash bin/sync-java.sh
    }
}
