#!/usr/bin/env nu
# Build Java JARs from assembled dist/java/<pkg>/ directories.
#
# Runs `gradle build` in each package directory to compile and test the
# generated Java sources. Optionally publishes to Maven Central via the
# Central Portal.
#
# Prerequisites:
#   - dist/java/ must already be populated (run `pixi run -e haskell sync-java`
#     or `pixi run sync-all`).
#   - Java 17+ on PATH (required by the nmcp/Central Portal Gradle plugin).
#   - For --publish: signing keys and Central Portal credentials in
#     ~/.gradle/gradle.properties (see Release process wiki page).
#
# Packages are built in dependency order:
#   hydra-kernel (no deps) -> hydra-rdf -> hydra-pg, hydra-java
#
# Usage (from repo root):
#   nu pixi-scripts/build-java.nu
#   nu pixi-scripts/build-java.nu --no-tests
#   nu pixi-scripts/build-java.nu --publish    # publish to Maven Central

def main [
    --publish    # Run publishAggregationToCentralPortal instead of build
    --no-tests   # Skip tests (-x test passed to Gradle)
] {
    # Dependency order per the release process wiki.
    let packages = ["hydra-kernel", "hydra-rdf", "hydra-pg", "hydra-java"]

    let task = if $publish { "publishAggregationToCentralPortal" } else { "build" }
    let gradle_flags = if $no_tests { [$task "-x" "test"] } else { [$task] }

    print $"Building Java artifacts \(task: ($task)\)..."
    print ""

    mut built = []
    mut skipped = []

    for pkg in $packages {
        let pkg_dir = $"dist/java/($pkg)"
        if not ($pkg_dir | path exists) {
            print $"  SKIP    ($pkg)  -- ($pkg_dir) not found; run sync-java first"
            $skipped = ($skipped | append $pkg)
            continue
        }
        print $"  Building ($pkg)..."
        # Each dist/java/<pkg>/ has its own build.gradle + settings.gradle.
        ^bash -c $"cd ($pkg_dir) && gradle ($gradle_flags | str join ' ')"
        $built = ($built | append $pkg)
        print ""
    }

    print ""
    if ($built | length) > 0 {
        print $"Built ($built | length) package\(s\): ($built | str join ', ')"
    }
    if ($skipped | length) > 0 {
        print $"Skipped ($skipped | length) package\(s\) \(not yet generated\): ($skipped | str join ', ')"
    }
}
