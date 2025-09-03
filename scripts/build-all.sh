#!/bin/bash
set -euo pipefail

# Hydra Build All Script
# This script builds all conda packages in the correct order

echo "Building all Hydra conda packages..."
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
total_builds=0

build_recipe() {
    local recipe_name="$1"
    local recipe_dir="recipes/$recipe_name"

    total_builds=$((total_builds + 1))
    echo -e "\n${YELLOW}Building $recipe_name...${NC}"

    if [ ! -d "$recipe_dir" ]; then
        echo -e "${RED}Error: Recipe directory $recipe_dir not found${NC}"
        return 1
    fi

    if rattler-build build --recipe-dir "$recipe_dir"; then
        echo -e "${GREEN}✓ Successfully built $recipe_name${NC}"
        success_count=$((success_count + 1))
        return 0
    else
        echo -e "${RED}✗ Failed to build $recipe_name${NC}"
        return 1
    fi
}

# Build packages in dependency order
echo "Building Python package (no dependencies)..."
build_recipe "hydra-python" || echo -e "${YELLOW}Warning: Python build failed${NC}"

echo -e "\nBuilding Java package..."
build_recipe "hydra-java" || echo -e "${YELLOW}Warning: Java build failed${NC}"

echo -e "\nBuilding Scala package..."
build_recipe "hydra-scala" || echo -e "${YELLOW}Warning: Scala build failed${NC}"

# Skip Haskell packages due to known issues
echo -e "\n${YELLOW}Skipping Haskell packages due to known linking issues${NC}"
echo "  - hydra-haskell: glibc compatibility issues"
echo "  - hydra-ext: depends on hydra-haskell"
echo "  See PIXI_TASK_STATUS.md for details"

# Summary
echo -e "\n${YELLOW}Build Summary${NC}"
echo "============="
echo "Attempted builds: $total_builds"
echo "Successful builds: $success_count"

if [ $success_count -eq $total_builds ]; then
    echo -e "${GREEN}All attempted builds succeeded!${NC}"
    exit 0
elif [ $success_count -gt 0 ]; then
    echo -e "${YELLOW}Some builds succeeded, some failed. Check output above.${NC}"
    exit 1
else
    echo -e "${RED}All builds failed. Check configuration and dependencies.${NC}"
    exit 1
fi
