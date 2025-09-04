#!/usr/bin/env nu

# Hydra Build All Script
# This script builds all conda packages in the correct order

print "Building all Hydra conda packages..."
print "===================================="

# Colors for output
let RED = "\u{001b}[0;31m"
let GREEN = "\u{001b}[0;32m"
let YELLOW = "\u{001b}[1;33m"
let NC = "\u{001b}[0m" # No Color

mut success_count = 0
mut total_builds = 0

def build_recipe [recipe_name: string] {
    let recipe_dir = $"recipes/($recipe_name)"

    $env.total_builds = ($env.total_builds + 1)
    print $"($env.YELLOW)Building ($recipe_name)...($env.NC)"

    if not ($recipe_dir | path exists) {
        print $"($env.RED)Error: Recipe directory ($recipe_dir) not found($env.NC)"
        return false
    }

    let result = do { ^rattler-build build --recipe-dir $recipe_dir } | complete

    if $result.exit_code == 0 {
        print $"($env.GREEN)[+] Successfully built ($recipe_name)($env.NC)"
        $env.success_count = ($env.success_count + 1)
        return true
    } else {
        print $"($env.RED)[-] Failed to build ($recipe_name)($env.NC)"
        return false
    }
}

# Set up environment variables
$env.RED = $RED
$env.GREEN = $GREEN
$env.YELLOW = $YELLOW
$env.NC = $NC
$env.success_count = $success_count
$env.total_builds = $total_builds

# Build packages in dependency order
print "Building Python package (no dependencies)..."
let python_result = build_recipe "hydra-python"
if not $python_result {
    print $"($YELLOW)Warning: Python build failed($NC)"
}

print "\nBuilding Java package..."
let java_result = build_recipe "hydra-java"
if not $java_result {
    print $"($YELLOW)Warning: Java build failed($NC)"
}

print "\nBuilding Scala package..."
let scala_result = build_recipe "hydra-scala"
if not $scala_result {
    print $"($YELLOW)Warning: Scala build failed($NC)"
}

# Skip Haskell packages due to known issues
print $"\n($YELLOW)Skipping Haskell packages due to known linking issues($NC)"
print "  - hydra-haskell: glibc compatibility issues"
print "  - hydra-ext: depends on hydra-haskell"
print "  See PIXI_TASK_STATUS.md for details"

# Summary
print $"\n($YELLOW)Build Summary($NC)"
print "============="
print $"Attempted builds: ($env.total_builds)"
print $"Successful builds: ($env.success_count)"

if $env.success_count == $env.total_builds {
    print $"($GREEN)All attempted builds succeeded!($NC)"
    exit 0
} else if $env.success_count > 0 {
    print $"($YELLOW)Some builds succeeded, some failed. Check output above.($NC)"
    exit 1
} else {
    print $"($RED)All builds failed. Check configuration and dependencies.($NC)"
    exit 1
}
