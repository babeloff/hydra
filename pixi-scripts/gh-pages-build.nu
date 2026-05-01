#!/usr/bin/env nu
# Prepare the docs-output directory for GitHub Pages deployment.
#
# Depends on: docs-html (must be run first via pixi task dependency)
#
# Adds a .nojekyll file so GitHub Pages serves the raw HTML without Jekyll
# processing, and copies any CNAME file if present.
#
# Usage (from repo root):
#   nu pixi-scripts/gh-pages-build.nu

def main [] {
    let out = "docs-output"

    if not ($out | path exists) {
        print $"ERROR: ($out) does not exist. Run 'pixi run docs-html' first."
        exit 1
    }

    print "Preparing GitHub Pages output..."

    # Disable Jekyll processing so GitHub Pages serves the HTML as-is.
    touch $"($out)/.nojekyll"
    print "  Created .nojekyll"

    # Copy CNAME if present at repo root (needed for custom domain).
    if ("CNAME" | path exists) {
        cp CNAME $"($out)/CNAME"
        print "  Copied CNAME"
    }

    print ""
    print $"GitHub Pages output ready in ($out)/"
}
