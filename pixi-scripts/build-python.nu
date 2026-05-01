#!/usr/bin/env nu
# Build Python wheels and sdists from assembled dist/python/<pkg>/ directories.
#
# Runs `python -m build` in each package directory, producing .whl and .tar.gz
# artifacts in the `wheels/` directory at the repo root.
#
# Prerequisites:
#   - dist/python/ must already be populated (run `pixi run build-haskell` then
#     `pixi run -e haskell sync-python`, or `pixi run sync-all`).
#   - The `build` Python package must be available (`python -m build`).
#
# Packages are built in dependency order:
#   hydra-kernel (no deps) -> hydra-rdf, hydra-ext -> hydra-pg -> hydra-python
#
# To publish to PyPI after building:
#   twine upload wheels/*.whl wheels/*.tar.gz
#   # or: uv publish wheels/*.whl
#
# Usage (from repo root):
#   nu pixi-scripts/build-python.nu
#   nu pixi-scripts/build-python.nu --outdir /tmp/my-wheels

def main [
    --outdir: string = "wheels"  # Output directory for .whl and .tar.gz artifacts
] {
    # Dependency order: kernel first, then independent extensions, then dependents.
    let packages = ["hydra-kernel", "hydra-rdf", "hydra-ext", "hydra-pg", "hydra-python"]

    let abs_outdir = ($outdir | path expand)
    mkdir $abs_outdir

    print $"Building Python wheels into ($abs_outdir)/..."
    print ""

    mut built = []
    mut skipped = []

    for pkg in $packages {
        let pkg_dir = $"dist/python/($pkg)"
        if not ($pkg_dir | path exists) {
            print $"  SKIP    ($pkg)  -- ($pkg_dir) not found; run sync-python first"
            $skipped = ($skipped | append $pkg)
            continue
        }
        print $"  Building ($pkg)..."
        ^python -m build --wheel --sdist --outdir $abs_outdir $pkg_dir
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

    let artifacts = (ls $abs_outdir | where name =~ '\.(whl|tar\.gz)$' | get name)
    if ($artifacts | length) > 0 {
        print ""
        print "Artifacts:"
        for f in $artifacts {
            print $"  ($f)"
        }
    }
}
