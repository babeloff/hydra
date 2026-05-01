#!/usr/bin/env nu
# Launch GHCi with a fixed package set to avoid version-resolution conflicts.
#
# Loads only the core hydra library (hydra:lib) without the test or ext
# packages. Use this when ghci-all produces dependency version conflicts
# or when you only need the kernel and generation APIs.
#
# Usage (from repo root):
#   pixi run -e haskell ghci-all-fixed

def main [] {
    ^stack ghci --system-ghc hydra:lib
}
