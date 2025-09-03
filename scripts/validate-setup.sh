#!/bin/bash
set -euo pipefail

# Hydra Pixi Setup Validation Script
# This script validates that the pixi project is properly configured

echo "Hydra Pixi Setup Validation"
echo "==========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
total_checks=0

check() {
    local description="$1"
    local command="$2"

    total_checks=$((total_checks + 1))
    echo -n "Checking ${description}... "

    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}✗${NC}"
    fi
}

echo "1. Checking pixi installation and basic setup"
echo "--------------------------------------------"

check "pixi command availability" "command -v pixi"
check "pixi.toml exists" "[ -f pixi.toml ]"
check "pixi project info" "pixi info"

echo ""
echo "2. Checking recipe files"
echo "------------------------"

check "recipes directory exists" "[ -d recipes ]"
check "main recipe exists" "[ -f recipes/recipe.yaml ]"
check "main build script embedded in recipe" "grep -q 'script:' recipes/recipe.yaml && grep -q 'content:' recipes/recipe.yaml"
check "hydra-java recipe exists" "[ -f recipes/hydra-java/recipe.yaml ]"
check "hydra-python recipe exists" "[ -f recipes/hydra-python/recipe.yaml ]"
check "hydra-haskell recipe exists" "[ -f recipes/hydra-haskell/recipe.yaml ]"
check "hydra-scala recipe exists" "[ -f recipes/hydra-scala/recipe.yaml ]"
check "hydra-ext recipe exists" "[ -f recipes/hydra-ext/recipe.yaml ]"

echo ""
echo "3. Checking recipe format compliance and wrapper scripts"
echo "--------------------------------------------------------"

check "main recipe uses proper rattler-build format" "grep -q 'name: \${{ name }}' recipes/recipe.yaml"
check "hydra-java recipe uses proper format" "grep -q 'interpreter: nushell' recipes/hydra-java/recipe.yaml"
check "hydra-python recipe uses proper format" "grep -q 'interpreter: nushell' recipes/hydra-python/recipe.yaml"
check "hydra-haskell recipe uses proper format" "grep -q 'interpreter: nushell' recipes/hydra-haskell/recipe.yaml"
check "hydra-scala recipe uses proper format" "grep -q 'interpreter: nushell' recipes/hydra-scala/recipe.yaml"
check "hydra-ext recipe uses proper format" "grep -q 'interpreter: nushell' recipes/hydra-ext/recipe.yaml"
check "recipes use 'tests:' not 'test:'" "! grep -q '^test:' recipes/*/recipe.yaml recipes/recipe.yaml"
check "recipes use 'homepage' not 'home'" "grep -q 'homepage:' recipes/hydra-java/recipe.yaml"
check "recipes use 'repository' not 'dev_url'" "grep -q 'repository:' recipes/hydra-java/recipe.yaml"
check "recipes use 'documentation' not 'doc_url'" "grep -q 'documentation:' recipes/hydra-java/recipe.yaml"
check "hydra-java wrapper script exists" "[ -f recipes/hydra-java/wrapper.sh ]"
check "hydra-scala wrapper script exists" "[ -f recipes/hydra-scala/wrapper.sh ]"
check "main hydra wrapper script exists" "[ -f recipes/hydra-wrapper.sh ]"
check "unified JVM wrapper script exists" "[ -f recipes/jvm-wrapper.sh ]"
check "wrapper scripts are executable" "[ -x recipes/hydra-java/wrapper.sh ]"

echo ""
echo "4. Checking source directories"
echo "------------------------------"

check "hydra-java source exists" "[ -d hydra-java/src ]"
check "hydra-python source exists" "[ -d hydra-python/src ]"
check "hydra-haskell source exists" "[ -d hydra-haskell/src ]"
check "hydra-scala source exists" "[ -d hydra-scala/src ]"
check "hydra-ext source exists" "[ -d hydra-ext/src ]"

echo ""
echo "5. Checking build configuration files"
echo "-------------------------------------"

check "Java build.gradle exists" "[ -f build.gradle ]"
check "hydra-java build.gradle exists" "[ -f hydra-java/build.gradle ]"
check "hydra-python pyproject.toml exists" "[ -f hydra-python/pyproject.toml ]"
check "hydra-haskell package.yaml exists" "[ -f hydra-haskell/package.yaml ]"
check "hydra-haskell stack.yaml exists" "[ -f hydra-haskell/stack.yaml ]"
check "hydra-scala build.sbt exists" "[ -f hydra-scala/build.sbt ]"

echo ""
echo "6. Checking nushell availability"
echo "--------------------------------"

check "nushell dependency" "pixi list | grep -q nushell"

echo ""
echo "7. Checking pixi environments"
echo "-----------------------------"

check "default environment" "pixi list -e default"
check "java environment" "pixi list -e java"
check "python environment" "pixi list -e python"
check "haskell environment" "pixi list -e haskell"
check "scala environment" "pixi list -e scala"
check "all environment" "pixi list -e all"

echo ""
echo "8. Checking pixi tasks"
echo "---------------------"

check "build-all task" "grep -q '^build-all = ' pixi.toml"
check "build-java task" "grep -q '^build-java = ' pixi.toml"
check "build-python task" "grep -q '^build-python = ' pixi.toml"
check "build-scala task" "grep -q '^build-scala = ' pixi.toml"
check "build-ext task" "grep -q '^build-ext = ' pixi.toml"
check "clean task" "grep -q '^clean = ' pixi.toml"
check "validate task" "grep -q '^validate = ' pixi.toml"

echo ""
echo "Summary"
echo "======="

if [ $success_count -eq $total_checks ]; then
    echo -e "${GREEN}✓ All $total_checks checks passed!${NC}"
    echo "The pixi setup is ready for building conda packages."
    exit 0
else
    failed_checks=$((total_checks - success_count))
    echo -e "${RED}✗ $failed_checks out of $total_checks checks failed.${NC}"
    echo ""
    echo "Please address the failed checks before proceeding with the build."
    echo "Common solutions:"
    echo "- Run 'pixi install' to install dependencies"
    echo "- Check that all source directories and files exist"
    echo "- Ensure recipes use proper rattler-build format with nushell scripts"
    echo "- Verify nushell is available as a dependency"
    exit 1
fi
