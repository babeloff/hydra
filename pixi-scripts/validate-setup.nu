#!/usr/bin/env nu

# Hydra Pixi Setup Validation Script
# This script validates that the pixi project is properly configured

print "Hydra Pixi Setup Validation"
print "==========================="

# Colors for output
let RED = "\u{001b}[0;31m"
let GREEN = "\u{001b}[0;32m"
let YELLOW = "\u{001b}[1;33m"
let NC = "\u{001b}[0m" # No Color

mut success_count = 0
mut total_checks = 0

def check [description: string, command: string] {
    $env.total_checks = ($env.total_checks + 1)
    print -n $"Checking ($description)... "

    let result = do { nu -c $command } | complete

    if $result.exit_code == 0 {
        print $"($env.GREEN)[+]($env.NC)"
        $env.success_count = ($env.success_count + 1)
    } else {
        print $"($env.RED)[-]($env.NC)"
    }
}

# Set up environment variables
$env.RED = $RED
$env.GREEN = $GREEN
$env.YELLOW = $YELLOW
$env.NC = $NC
$env.success_count = $success_count
$env.total_checks = $total_checks

print "1. Checking pixi installation and basic setup"
print "--------------------------------------------"

check "pixi command availability" "which pixi"
check "pixi.toml exists" "ls pixi.toml | length"
check "pixi project info" "pixi info"

print ""
print "2. Checking recipe files"
print "------------------------"

check "recipes directory exists" "ls recipes | length"
check "main recipe exists" "ls recipes/recipe.yaml | length"
check "main build script embedded in recipe" "open recipes/recipe.yaml | to yaml | get build.script? | is-not-empty"
check "hydra-java recipe exists" "ls recipes/hydra-java/recipe.yaml | length"
check "hydra-python recipe exists" "ls recipes/hydra-python/recipe.yaml | length"
check "hydra-haskell recipe exists" "ls recipes/hydra-haskell/recipe.yaml | length"
check "hydra-scala recipe exists" "ls recipes/hydra-scala/recipe.yaml | length"
check "hydra-ext recipe exists" "ls recipes/hydra-ext/recipe.yaml | length"

print ""
print "3. Checking recipe format compliance and wrapper scripts"
print "--------------------------------------------------------"

check "main recipe uses proper rattler-build format" "open recipes/recipe.yaml | to yaml | get package.name? | str contains '${{ name }}'"
check "hydra-java recipe uses proper format" "open recipes/hydra-java/recipe.yaml | to yaml | get build.script.interpreter? | str contains 'nushell'"
check "hydra-python recipe uses proper format" "open recipes/hydra-python/recipe.yaml | to yaml | get build.script.interpreter? | str contains 'nushell'"
check "hydra-haskell recipe uses proper format" "open recipes/hydra-haskell/recipe.yaml | to yaml | get build.script.interpreter? | str contains 'nushell'"
check "hydra-scala recipe uses proper format" "open recipes/hydra-scala/recipe.yaml | to yaml | get build.script.interpreter? | str contains 'nushell'"
check "hydra-ext recipe uses proper format" "open recipes/hydra-ext/recipe.yaml | to yaml | get build.script.interpreter? | str contains 'nushell'"
check "recipes use 'tests:' not 'test:'" "open recipes/hydra-java/recipe.yaml | to yaml | get test? | is-empty"
check "recipes use 'homepage' not 'home'" "open recipes/hydra-java/recipe.yaml | to yaml | get about.homepage? | is-not-empty"
check "recipes use 'repository' not 'dev_url'" "open recipes/hydra-java/recipe.yaml | to yaml | get about.repository? | is-not-empty"
check "recipes use 'documentation' not 'doc_url'" "open recipes/hydra-java/recipe.yaml | to yaml | get about.documentation? | is-not-empty"
check "hydra-java wrapper script exists" "ls recipes/hydra-java/wrapper.sh | length"
check "hydra-scala wrapper script exists" "ls recipes/hydra-scala/wrapper.sh | length"
check "main hydra wrapper script exists" "ls recipes/hydra-wrapper.sh | length"
check "unified JVM wrapper script exists" "ls recipes/jvm-wrapper.sh | length"
check "wrapper scripts are executable" "ls -la recipes/hydra-java/wrapper.sh | get mode | str contains 'x'"

print ""
print "4. Checking source directories"
print "------------------------------"

check "hydra-java source exists" "ls hydra-java/src | length"
check "hydra-python source exists" "ls hydra-python/src | length"
check "hydra-haskell source exists" "ls hydra-haskell/src | length"
check "hydra-scala source exists" "ls hydra-scala/src | length"
check "hydra-ext source exists" "ls hydra-ext/src | length"

print ""
print "5. Checking build configuration files"
print "-------------------------------------"

check "Java build.gradle exists" "ls build.gradle | length"
check "hydra-java build.gradle exists" "ls hydra-java/build.gradle | length"
check "hydra-python pyproject.toml exists" "ls hydra-python/pyproject.toml | length"
check "hydra-haskell package.yaml exists" "ls hydra-haskell/package.yaml | length"
check "hydra-haskell stack.yaml exists" "ls hydra-haskell/stack.yaml | length"
check "hydra-scala build.sbt exists" "ls hydra-scala/build.sbt | length"

print ""
print "6. Checking nushell availability"
print "--------------------------------"

check "nushell dependency" "pixi list | grep nushell"

print ""
print "7. Checking pixi environments"
print "-----------------------------"

check "default environment" "pixi list -e default"
check "java environment" "pixi list -e java"
check "python environment" "pixi list -e python"
check "haskell environment" "pixi list -e haskell"
check "scala environment" "pixi list -e scala"
check "all environment" "pixi list -e all"

print ""
print "8. Checking pixi tasks"
print "---------------------"

check "build-all task" "open pixi.toml | to toml | get tasks.build-all? | is-not-empty"
check "build-java task" "open pixi.toml | to toml | get tasks.build-java? | is-not-empty"
check "build-python task" "open pixi.toml | to toml | get tasks.build-python? | is-not-empty"
check "build-scala task" "open pixi.toml | to toml | get tasks.build-scala? | is-not-empty"
check "build-ext task" "open pixi.toml | to toml | get tasks.build-ext? | is-not-empty"
check "clean task" "open pixi.toml | to toml | get tasks.clean? | is-not-empty"
check "validate task" "open pixi.toml | to toml | get tasks.validate? | is-not-empty"

print ""
print "Summary"
print "======="

if $env.success_count == $env.total_checks {
    print $"($GREEN)[+] All ($env.total_checks) checks passed!($NC)"
    print "The pixi setup is ready for building conda packages."
    exit 0
} else {
    let failed_checks = ($env.total_checks - $env.success_count)
    print $"($RED)[-] ($failed_checks) out of ($env.total_checks) checks failed.($NC)"
    print ""
    print "Please address the failed checks before proceeding with the build."
    print "Common solutions:"
    print "- Run 'pixi install' to install dependencies"
    print "- Check that all source directories and files exist"
    print "- Ensure recipes use proper rattler-build format with nushell scripts"
    print "- Verify nushell is available as a dependency"
    exit 1
}
