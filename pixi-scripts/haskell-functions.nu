#!/usr/bin/env nu

# Haskell Functions Explorer
# This script searches for Haskell function type signatures in the generated code

print "Exploring Haskell function signatures in generated code..."

# Change to the hydra-haskell directory
cd hydra-haskell

print "Searching for function type signatures in src/gen-main/haskell/Hydra/*/*.hs..."

# Search for Haskell function type signatures
# Pattern matches: functionName :: Type -> Type
let pattern = '^[a-zA-Z_][a-zA-Z0-9_]*[ ]*::'

# Find all .hs files in the generated code directory and search for function signatures
let functions = (
    glob src/gen-main/haskell/Hydra/*/*.hs
    | each { |file|
        open $file
        | lines
        | enumerate
        | where item =~ $pattern
        | each { |line|
            {
                file: $file,
                line: ($line.index + 1),
                signature: $line.item
            }
        }
    }
    | flatten
)

if ($functions | length) > 0 {
    print $"Found ($functions | length) function signatures:"
    print ""

    # Display first 10 function signatures
    $functions
    | first 10
    | each { |func|
        print $"($func.file):($func.line):($func.signature)"
    }

    if ($functions | length) > 10 {
        let remaining = (($functions | length) - 10)
        print $"\n... and ($remaining) more functions"
    }
} else {
    print "No function signatures found. Make sure the Haskell code has been generated first."
    print "Run: pixi run -e haskell generate-haskell"
}

print "\nFunction exploration completed."
