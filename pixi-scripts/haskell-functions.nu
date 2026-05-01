#!/usr/bin/env nu
# List top-level Haskell function definitions in the source tree.
#
# Searches .hs files for top-level type signatures (name :: type) and
# prints them sorted by file path. Useful for quickly surveying the
# public API of the Haskell head.
#
# Runs from heads/haskell/ (cwd set in pixi.toml).
#
# Usage:
#   pixi run -e haskell haskell-functions

def main [
    dir: string = "src"  # Source directory to search (default: src)
] {
    let matches = (
        ^grep -r --include="*.hs" -n "^[a-z][a-zA-Z0-9_']*\\s*::" $dir
        | lines
        | sort
    )

    if ($matches | is-empty) {
        print $"No function signatures found in ($dir)"
    } else {
        $matches | each { |line| print $line }
        print ""
        print $"($matches | length) signatures found in ($dir)"
    }
}
