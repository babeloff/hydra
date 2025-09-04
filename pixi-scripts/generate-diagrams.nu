#!/usr/bin/env nu

# PlantUML Diagram Generation Script
# This script generates PNG images from PlantUML source files

print "Generating PlantUML diagrams..."
print "==============================="

let diagram_dir = "docs/diagrams"
let output_dir = "docs-output/images"

# Create output directory if it doesn't exist
mkdir $output_dir

# Find all .puml files in the diagrams directory
let puml_files = (ls $diagram_dir | where name ends-with '.puml' | get name)

if ($puml_files | length) == 0 {
    print "No PlantUML files found in docs/diagrams/"
    exit 0
}

print $"Found ($puml_files | length) PlantUML files"

# Generate each diagram
for file in $puml_files {
    let filename = ($file | path basename)
    let name_without_ext = ($filename | str replace ".puml" "")
    let output_file = $"($output_dir)/($name_without_ext).png"

    print $"Generating ($filename) -> ($name_without_ext).png"

    # Run PlantUML to generate the diagram (creates in same directory as source)
    let result = (do { plantuml -tpng $file } | complete)

    if $result.exit_code != 0 {
        print $"ERROR: Failed to generate ($filename)"
        print $"PlantUML output: ($result.stderr)"
        continue
    }

    # Copy the generated PNG to the output directory
    let source_png = ($file | str replace ".puml" ".png")
    if ($source_png | path exists) {
        cp $source_png $output_file
        rm $source_png
        print $"✓ Successfully generated ($name_without_ext).png"
    } else {
        print $"⚠ Warning: ($name_without_ext).png was not created"
    }
}

print ""
print "Diagram generation completed."
print $"Generated diagrams are in: ($output_dir)"

# List generated files
let generated_files = (ls $output_dir | where name ends-with '.png' | get name)
if ($generated_files | length) > 0 {
    print ""
    print "Generated files:"
    for file in $generated_files {
        let size = (ls $file | get size | first)
        print $"  - ($file | path basename) \(($size) bytes\)"
    }
}
