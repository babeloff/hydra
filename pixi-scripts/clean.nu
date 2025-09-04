#!/usr/bin/env nu

# Hydra Project Clean Script
# This script removes build artifacts and temporary files from all subprojects

print "Cleaning Hydra project build artifacts..."

# Remove common build directories
let build_dirs = [
    "build/"
    ".stack-work/"
    "target/"
    "dist/"
    ".gradle/"
]

for dir in $build_dirs {
    if ($dir | path exists) {
        print $"Removing ($dir)..."
        rm -rf $dir
    }
}

# Remove Python egg-info directories
print "Removing Python egg-info directories..."
glob **/*.egg-info | each { |dir|
    print $"Removing ($dir)..."
    rm -rf $dir
}

# Remove Python cache directories
print "Removing Python cache directories..."
glob **/__pycache__ | each { |dir|
    print $"Removing ($dir)..."
    rm -rf $dir
}

print "Clean completed successfully!"
