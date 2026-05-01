#!/usr/bin/env nu
# Generate PlantUML and Graphviz diagrams for documentation.
#
# Searches docs/ for standalone .puml / .plantuml (PlantUML) and .dot
# (Graphviz) source files and renders them to PNG images under docs-output/.
# Diagrams embedded inline in AsciiDoc files are processed automatically
# by asciidoctor-diagram during the docs-build step; this script handles
# standalone sources only.
#
# Requires the docs pixi feature environment (plantuml + graphviz on PATH).
#
# Usage (from repo root):
#   pixi run -e docs docs-generate-diagrams

def main [] {
    let output_dir = "docs-output/diagrams"

    # Collect standalone PlantUML sources.
    let puml_files = (
        ls docs/**/*.puml docs/**/*.plantuml 2>/dev/null
        | get name
        | default []
    )

    # Collect standalone Graphviz sources.
    let dot_files = (
        ls docs/**/*.dot 2>/dev/null
        | get name
        | default []
    )

    let total = (($puml_files | length) + ($dot_files | length))

    if $total == 0 {
        print "No standalone diagram sources found in docs/ -- nothing to generate."
        return
    }

    mkdir $output_dir

    if ($puml_files | length) > 0 {
        print $"Generating ($puml_files | length) PlantUML diagram\(s\)..."
        for f in $puml_files {
            print $"  ($f)"
            ^plantuml -o $"../../($output_dir)" $f
        }
    }

    if ($dot_files | length) > 0 {
        print $"Generating ($dot_files | length) Graphviz diagram\(s\)..."
        for f in $dot_files {
            let stem = ($f | path basename | str replace ".dot" "")
            let out = $"($output_dir)/($stem).png"
            print $"  ($f) -> ($out)"
            ^dot -Tpng $f -o $out
        }
    }

    print ""
    print $"Diagrams written to ($output_dir)/"
}
