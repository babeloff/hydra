#!/usr/bin/env nu
# Build all Hydra implementations (full all-hosts x all-targets sync matrix).
#
# Runs the complete sync pipeline for every supported host and target language:
# Haskell, Java, Python, Scala, Clojure, Scheme, Common Lisp, and Emacs Lisp.
#
# For the common bootstrapping triad (Haskell, Java, Python) only, use:
#   bash bin/sync-default.sh
#
# Usage (from repo root):
#   nu pixi-scripts/build-all.nu
#   nu pixi-scripts/build-all.nu --no-tests

def main [
    --no-tests  # Skip target-language tests after each sync step
] {
    if $no_tests {
        ^bash bin/sync.sh --hosts all --targets all --no-tests
    } else {
        ^bash bin/sync.sh --hosts all --targets all
    }
}
