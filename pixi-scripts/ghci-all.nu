#!/usr/bin/env nu
# Launch GHCi loaded with all Hydra Haskell packages (hydra lib + test + ext).
#
# Loads hydra:lib, hydra:hydra-test, and hydra-ext together so you can
# interactively call any function from the full Hydra Haskell surface.
# Requires the haskell pixi feature environment (GHCup-managed GHC + Stack).
#
# Usage (from repo root):
#   pixi run -e haskell ghci-all

def main [] {
    ^stack ghci --system-ghc hydra:lib hydra:hydra-test hydra-ext
}
