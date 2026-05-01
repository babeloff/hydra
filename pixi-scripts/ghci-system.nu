#!/usr/bin/env nu
# Launch GHCi using the system GHC directly, bypassing Stack's sandbox.
#
# Uses GHCup-managed GHC (on PATH via the haskell feature activation script)
# without going through Stack. Useful for quick REPL sessions that don't
# need the full Stack package set.
#
# Usage (from repo root):
#   pixi run -e haskell ghci-system

def main [] {
    ^stack ghci --system-ghc
}
