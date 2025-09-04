# Hydra Documentation Build System

This directory contains the complete documentation for the Hydra project, including developer guides, implementor guides, and operator guides. The documentation is written in AsciiDoc format and includes PlantUML diagrams for visual representation of architectural concepts.

## Directory Structure

```
docs/
├── README.md                    # This file
├── index.adoc                   # Main documentation index
├── developer-guide.adoc         # Complete developer guide
├── implementor-guide.adoc       # Guide for creating new implementations
├── operator-guide.adoc          # Guide for data transformation operators
├── diagrams/                    # PlantUML source files
│   ├── README.md                # Diagram maintenance guide
│   ├── *.puml                   # PlantUML diagram sources
├── sects/                       # Individual documentation sections
│   ├── architecture-setup.adoc
│   ├── build-system.adoc
│   ├── pixi-setup.adoc
│   └── ... (other sections)
├── images/                      # Static images (if any)
└── DIAGRAM_MIGRATION.md         # Summary of diagram conversion process
```

## Quick Start

### Prerequisites

Make sure you have the documentation environment set up:

```bash
# Install documentation dependencies
pixi install -e docs
```

### Building Documentation

#### HTML Documentation

```bash
# Build all HTML documentation
pixi run docs-html

# Build specific guides
pixi run -e docs docs-build-developer-guide
pixi run -e docs docs-build-implementor-guide
pixi run -e docs docs-build-operator-guide
```

#### PDF Documentation

```bash
# Build all PDF documentation
pixi run docs-pdf

# Build specific PDFs
pixi run -e docs docs-build-pdf-developer
pixi run -e docs docs-build-pdf-implementor
pixi run -e docs docs-build-pdf-operator
```

#### Complete Build

```bash
# Build both HTML and PDF versions
pixi run docs-all
```

### Viewing Documentation

#### Local Development Server

```bash
# Start local server to view HTML documentation
pixi run docs-serve

# Then open http://localhost:8080 in your browser
```

#### GitHub Pages Deployment

```bash
# Build and prepare for GitHub Pages
pixi run gh-pages-build

# The gh-pages/ directory will contain deployment-ready files
```

## Documentation Architecture

### AsciiDoc Format

The documentation uses AsciiDoc markup language with the following features:

- **Cross-references**: Links between sections and documents
- **Code highlighting**: Syntax highlighting for multiple languages
- **PlantUML diagrams**: Embedded diagrams generated from source
- **Table of contents**: Automatic TOC generation
- **Modular structure**: Reusable sections via includes

### PlantUML Integration

All diagrams are created using PlantUML and stored in the `diagrams/` directory:

- **Source files**: `.puml` files contain diagram definitions
- **Generated images**: PNG images generated during build
- **Embedding**: Diagrams embedded via AsciiDoc includes

### Build Process

1. **Preparation**: Clean output directory, generate diagrams
2. **Processing**: AsciiDoc processes files with PlantUML extension
3. **Output**: HTML and/or PDF files generated in `docs-output/`
4. **Deployment**: Files prepared for GitHub Pages or other hosting

## Writing Documentation

### Adding New Sections

1. Create new `.adoc` file in `docs/sects/`
2. Add content using AsciiDoc markup
3. Include in main guide using `include::sects/filename.adoc[]`
4. Update table of contents if needed

### Adding Diagrams

1. Create `.puml` file in `docs/diagrams/`
2. Follow naming convention: `descriptive-name.puml`
3. Use standard theme and styling (see `diagrams/README.md`)
4. Embed in documentation:
   ```asciidoc
   [plantuml,diagram-name,png]
   ....
   include::../diagrams/diagram-file.puml[]
   ....
   ```

### AsciiDoc Guidelines

#### Document Structure

```asciidoc
= Document Title
:toc: left
:toclevels: 3
:sectlinks:
:sectanchors:
:source-highlighter: pygments

Introduction paragraph.

== Main Section

Content here.

=== Subsection

More content.
```

#### Code Blocks

```asciidoc
[source,bash]
----
pixi run docs-html
----

[source,haskell]
----
module Main where
main = putStrLn "Hello, World!"
----
```

#### Cross-References

```asciidoc
See the <<build-system#,Build System Guide>> for details.
```

#### Notes and Warnings

```asciidoc
NOTE: This is an informational note.

WARNING: This is a warning about potential issues.

TIP: This is a helpful tip for users.
```

## Available Pixi Tasks

### Documentation Build Tasks

| Task | Description |
|------|-------------|
| `docs-html` | Build all HTML documentation |
| `docs-pdf` | Build all PDF documentation |
| `docs-all` | Build both HTML and PDF |
| `docs-serve` | Start local development server |
| `gh-pages-build` | Prepare for GitHub Pages deployment |

### Environment-Specific Tasks

Use `pixi run -e docs <task>` for these tasks:

| Task | Description |
|------|-------------|
| `docs-build-all-html` | Build all HTML guides |
| `docs-build-all-pdf` | Build all PDF guides |
| `docs-build-developer-guide` | Build developer guide HTML |
| `docs-build-implementor-guide` | Build implementor guide HTML |
| `docs-build-operator-guide` | Build operator guide HTML |
| `docs-build-pdf-developer` | Build developer guide PDF |
| `docs-build-pdf-implementor` | Build implementor guide PDF |
| `docs-build-pdf-operator` | Build operator guide PDF |
| `docs-clean` | Clean output directory |
| `docs-prepare` | Prepare build environment |
| `docs-generate-diagrams` | Generate PlantUML diagrams |

## Development Workflow

### Daily Documentation Development

1. **Edit content** in `.adoc` files
2. **Add/modify diagrams** in `diagrams/` directory
3. **Build and preview**:
   ```bash
   pixi run docs-html
   pixi run docs-serve
   ```
4. **Check output** at http://localhost:8080
5. **Iterate** until satisfied

### Before Committing

1. **Build all formats**:
   ```bash
   pixi run docs-all
   ```
2. **Check for errors** in build output
3. **Review generated files** in `docs-output/`
4. **Validate diagrams** render correctly
5. **Test GitHub Pages build**:
   ```bash
   pixi run gh-pages-build
   ```

### Release Process

1. **Update version references** throughout documentation
2. **Build complete documentation**:
   ```bash
   pixi run docs-all
   ```
3. **Generate GitHub Pages**:
   ```bash
   pixi run gh-pages-build
   ```
4. **Deploy to gh-pages branch**
5. **Update any external documentation links**

## Troubleshooting

### Common Issues

#### PlantUML Diagrams Not Rendering

- **Check PlantUML installation**: Verify `plantuml` command works
- **Verify diagram syntax**: Test `.puml` files individually
- **Check include paths**: Ensure relative paths are correct
- **Review build output**: Look for PlantUML error messages

#### AsciiDoc Processing Errors

- **Syntax validation**: Check AsciiDoc markup syntax
- **Missing includes**: Verify all include files exist
- **Cross-reference errors**: Check internal link targets
- **Attribute errors**: Verify document attributes are set

#### Build Environment Issues

- **Dependencies**: Ensure all docs dependencies are installed
- **Ruby environment**: Check Ruby and gem versions
- **Java requirement**: PlantUML requires Java runtime
- **Path issues**: Verify all tools are in PATH

### Debugging Commands

```bash
# Test individual diagram generation
plantuml -tpng docs/diagrams/your-diagram.puml

# Test AsciiDoc processing without PlantUML
asciidoctor docs/developer-guide.adoc

# Test with diagram processing
asciidoctor -r asciidoctor-diagram docs/developer-guide.adoc

# Check dependencies
pixi list -e docs

# Clean and rebuild
pixi run -e docs docs-clean
pixi run docs-all
```

## Contributing to Documentation

### Style Guidelines

1. **Use clear, concise language**
2. **Follow AsciiDoc best practices**
3. **Include practical examples**
4. **Keep diagrams simple and focused**
5. **Test all code examples**
6. **Maintain consistent terminology**

### Review Process

1. **Technical accuracy**: Verify all technical content
2. **Grammar and style**: Check for clarity and readability
3. **Link validation**: Ensure all cross-references work
4. **Diagram quality**: Review visual elements
5. **Build testing**: Confirm all formats generate correctly

### Maintenance

- **Regular updates**: Keep content current with codebase changes
- **Link checking**: Verify external links periodically
- **Version alignment**: Ensure documentation matches software versions
- **Feedback incorporation**: Address user feedback and questions

## Integration with Development Workflow

### Continuous Integration

The documentation build can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions step
- name: Build Documentation
  run: |
    pixi install -e docs
    pixi run docs-all
    pixi run gh-pages-build
```

### Local Development

Documentation builds automatically when:

- PlantUML diagrams are updated
- AsciiDoc content is modified
- Build dependencies are available
- Output directory is clean

## Resources

### Documentation Tools

- **AsciiDoc**: https://asciidoc.org/
- **Asciidoctor**: https://asciidoctor.org/
- **PlantUML**: https://plantuml.com/
- **Pixi**: https://pixi.sh/

### Hydra-Specific Resources

- **Main Repository**: https://github.com/CategoricalData/hydra
- **Community Discord**: https://bit.ly/lg-discord
- **Documentation Issues**: Use main repository issue tracker
- **Style Guide**: Follow existing documentation patterns

For questions about documentation, please reach out via the Discord community or create an issue in the main repository.