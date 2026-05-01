#!/usr/bin/env nu
# Validate that the Hydra project environment is correctly set up.
#
# Checks that required tools are available and reports their versions.
# Exits with a non-zero status if any required tool is missing.
#
# Usage (from repo root):
#   nu pixi-scripts/validate-setup.nu

def check_tool [name: string, required: bool = true] -> bool {
    let result = (which $name)
    if ($result | is-empty) {
        if $required {
            print $"  MISSING  ($name)"
        } else {
            print $"  optional ($name) -- not found"
        }
        false
    } else {
        let path = ($result | first | get path)
        print $"  ok       ($name)  ($path)"
        true
    }
}

def main [] {
    print "Validating Hydra project setup..."
    print ""

    mut ok = true

    # Core build tools
    print "Required tools:"
    if not (check_tool "stack") { $ok = false }
    if not (check_tool "java") { $ok = false }
    if not (check_tool "python3") { $ok = false }
    if not (check_tool "nu") { $ok = false }
    if not (check_tool "bash") { $ok = false }
    if not (check_tool "git") { $ok = false }

    print ""
    print "Optional tools:"
    check_tool "uv" false
    check_tool "sbt" false
    check_tool "rattler-build" false
    check_tool "pyright" false
    check_tool "ruff" false

    print ""

    # Check key directories
    print "Key directories:"
    for dir in ["heads/haskell", "heads/java", "heads/python", "heads/scala", "dist/json"] {
        if ($dir | path exists) {
            print $"  ok       ($dir)"
        } else {
            print $"  MISSING  ($dir)"
            $ok = false
        }
    }

    print ""

    # Check VERSION file
    if ("VERSION" | path exists) {
        let version = (open VERSION | str trim)
        print $"Version: ($version)"
    } else {
        print "WARNING: VERSION file not found"
    }

    print ""

    if $ok {
        print "Setup looks good."
    } else {
        print "Setup validation FAILED -- missing required tools or directories."
        exit 1
    }
}
