#!/usr/bin/env nu

# GitHub Pages Build Script
# This script prepares documentation for GitHub Pages deployment

print "Building documentation for GitHub Pages..."
print "=========================================="

# Set up directories
let docs_output = "docs-output"
let gh_pages_dir = "gh-pages"

# Clean and create gh-pages directory
if ($gh_pages_dir | path exists) {
    rm -rf $gh_pages_dir
}
mkdir $gh_pages_dir

# Check if docs-output exists
if not ($docs_output | path exists) {
    print "ERROR: docs-output directory not found. Run 'pixi run docs-html' first."
    exit 1
}

print "Copying documentation files to gh-pages directory..."

# Copy all HTML files
let html_files = (ls $docs_output | where name =~ "\.html$")
for file in $html_files {
    let filename = ($file.name | path basename)
    cp $file.name $"($gh_pages_dir)/($filename)"
    print $"  ✓ Copied ($filename)"
}

# Copy all PDF files if they exist
let pdf_files = (ls $docs_output | where name =~ "\.pdf$")
for file in $pdf_files {
    let filename = ($file.name | path basename)
    cp $file.name $"($gh_pages_dir)/($filename)"
    print $"  ✓ Copied ($filename)"
}

# Copy images directory if it exists
let images_dir = $"($docs_output)/images"
if ($images_dir | path exists) {
    cp -r $images_dir $"($gh_pages_dir)/images"
    print "  ✓ Copied images directory"

    # List diagram images
    let diagram_files = (ls $"($gh_pages_dir)/images" | where name =~ "\.png$")
    if ($diagram_files | length) > 0 {
        print $"    - Found ($diagram_files | length) diagram images"
    }
}

# Copy any CSS files if they exist
let css_files = (ls $docs_output | where name =~ "\.css$")
for file in $css_files {
    let filename = ($file.name | path basename)
    cp $file.name $"($gh_pages_dir)/($filename)"
    print $"  ✓ Copied ($filename)"
}

# Create a simple index redirect if index.html doesn't exist
if not ($"($gh_pages_dir)/index.html" | path exists) {
    let index_content = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydra Documentation</title>
    <meta http-equiv="refresh" content="0; url=developer-guide.html">
</head>
<body>
    <h1>Hydra Documentation</h1>
    <p>Redirecting to <a href="developer-guide.html">Developer Guide</a>...</p>
    <ul>
        <li><a href="developer-guide.html">Developer Guide</a></li>
        <li><a href="implementor-guide.html">Implementor Guide</a></li>
        <li><a href="operator-guide.html">Operator Guide</a></li>
    </ul>
</body>
</html>'
    $index_content | save $"($gh_pages_dir)/index.html"
    print "  ✓ Created index.html redirect"
}

# Create .nojekyll file to prevent Jekyll processing
"" | save $"($gh_pages_dir)/.nojekyll"
print "  ✓ Created .nojekyll file"

# Create CNAME file if needed (uncomment and modify for custom domain)
# "docs.hydra-lang.org" | save $"($gh_pages_dir)/CNAME"
# print "  ✓ Created CNAME file"

print ""
print "GitHub Pages build completed successfully!"
print $"Files are ready in: ($gh_pages_dir)/"

# Summary of files
let total_files = (ls $gh_pages_dir | length)
let html_count = (ls $gh_pages_dir | where name =~ "\.html$" | length)
let pdf_count = (ls $gh_pages_dir | where name =~ "\.pdf$" | length)

print $"Summary:"
print $"  - Total files: ($total_files)"
print $"  - HTML files: ($html_count)"
print $"  - PDF files: ($pdf_count)"

if ($"($gh_pages_dir)/images" | path exists) {
    let image_count = (ls $"($gh_pages_dir)/images" | length)
    print $"  - Images: ($image_count)"
}

print ""
print "Next steps:"
print "1. Review files in gh-pages/ directory"
print "2. Commit and push to gh-pages branch:"
print "   cd gh-pages && git add . && git commit -m 'Update documentation' && git push origin gh-pages"
print "3. Check GitHub Pages deployment at your repository's Pages URL"
