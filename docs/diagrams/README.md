# Hydra Documentation Diagrams

This directory contains PlantUML source files for all diagrams used in the Hydra documentation. The diagrams are embedded in AsciiDoc files using the PlantUML plugin and provide visual representations of Hydra's architecture, workflows, and concepts.

## Directory Structure

```
diagrams/
├── README.md                           # This file
├── code-generation-pipeline.puml      # Code generation sequence diagram
├── data-transformation-model.puml     # Data transformation conceptual model
├── dependency-tiers.puml              # Dependency tier relationships
├── documentation-architecture.puml    # Documentation system architecture
├── implementor-workflow.puml          # Step-by-step implementor process
├── recipes-structure.puml             # Recipe directory structure
└── transformation-pipeline.puml       # Multi-step data transformation flow
```

## Usage in Documentation

The PlantUML files are included in AsciiDoc documents using the following syntax:

```asciidoc
[plantuml,diagram-name,png]
....
include::../diagrams/diagram-file.puml[]
....
```

### Current Diagram Usage

| Diagram File | Used In | Purpose |
|-------------|---------|---------|
| `code-generation-pipeline.puml` | `code-generation.adoc` | Shows the flow from DSL sources to native binaries |
| `data-transformation-model.puml` | `operator-fundamentals.adoc` | Illustrates Hydra's data transformation concepts |
| `dependency-tiers.puml` | `dependency-tiers.adoc` | Visualizes the tier-based dependency structure |
| `documentation-architecture.puml` | `documentation-system.adoc` | Documentation build and deployment architecture |
| `implementor-workflow.puml` | `implementor-steps.adoc` | Step-by-step workflow for creating new implementations |
| `recipes-structure.puml` | `architecture-setup.adoc` | Recipe directory organization |
| `transformation-pipeline.puml` | `transformation-examples.adoc` | Multi-step transformation example |

## PlantUML Standards

All diagrams follow these conventions:

### Theme and Styling
- Use `!theme plain` for consistent appearance
- Set `skinparam backgroundColor white` for light backgrounds
- Use `skinparam defaultFontName Arial` for consistency

### Diagram Types Used
- **Sequence Diagrams**: For process flows and interactions
- **Component Diagrams**: For architectural structures
- **Activity Diagrams**: For workflows and step-by-step processes
- **Folder Structure Diagrams**: For directory layouts

### Color and Layout Guidelines
- Keep diagrams simple and clean
- Use consistent shapes for similar concepts:
  - `file` for files and data sources
  - `folder` for directories
  - `component` for system components
  - `process` for transformations
  - `rectangle` for logical groupings
- Use notes sparingly for important clarifications
- Maintain consistent arrow styles for relationships

## Editing Diagrams

### Prerequisites
- PlantUML installed locally (optional, for testing)
- Text editor with PlantUML syntax support
- Access to PlantUML online server for quick previews

### Development Workflow

1. **Edit the `.puml` file** directly in this directory
2. **Test locally** (if PlantUML is installed):
   ```bash
   plantuml diagram-name.puml
   ```
3. **Preview online** at http://www.plantuml.com/plantuml/uml/
4. **Update documentation** - the AsciiDoc files will automatically use the updated diagram
5. **Commit both** the `.puml` file and any generated images

### Testing Changes

When modifying diagrams:

1. Ensure the diagram renders correctly
2. Verify it displays properly in the documentation context
3. Check that notes and labels are readable
4. Confirm the diagram adds value to the documentation

## Adding New Diagrams

To add a new diagram:

1. **Create the `.puml` file** in this directory
2. **Follow naming conventions**: Use lowercase with hyphens (e.g., `new-concept-diagram.puml`)
3. **Include standard header**:
   ```plantuml
   @startuml
   !theme plain
   skinparam backgroundColor white
   skinparam defaultFontName Arial
   ```
4. **Add the diagram content**
5. **Include standard footer**: `@enduml`
6. **Reference in documentation** using the include syntax
7. **Update this README** with the new diagram information

## Maintenance

### Regular Updates

- Review diagrams when code architecture changes
- Update diagrams when new features are added
- Ensure diagram consistency across the documentation
- Verify all links and includes work correctly

### Version Control

- Always commit both `.puml` source files and generated images
- Use descriptive commit messages for diagram changes
- Review diagram changes as part of documentation reviews

### Quality Checks

Before committing diagram changes:

- [ ] Diagram renders without errors
- [ ] Text is readable at normal viewing size  
- [ ] Consistent with other diagrams in style
- [ ] Adds clear value to the documentation
- [ ] Notes and labels are grammatically correct
- [ ] Follows the established theme and styling

## Troubleshooting

### Common Issues

**Diagram not rendering in documentation:**
- Check the include path is correct (`../diagrams/filename.puml`)
- Verify the `.puml` file syntax is valid
- Ensure AsciiDoc processor supports PlantUML

**Syntax errors in PlantUML:**
- Validate syntax using online PlantUML editor
- Check for missing `@startuml` or `@enduml` tags
- Verify all quotes and parentheses are balanced

**Inconsistent styling:**
- Ensure all diagrams use the standard header
- Check skinparam settings are consistent
- Verify theme usage across all diagrams

### Resources

- [PlantUML Official Documentation](https://plantuml.com/)
- [PlantUML Language Reference](https://plantuml.com/guide)
- [AsciiDoc PlantUML Integration](https://asciidoctor.org/docs/asciidoctor-diagram/)
- [Online PlantUML Editor](http://www.plantuml.com/plantuml/uml/)

## Contributing

When contributing new diagrams or updates:

1. Follow the established conventions in this README
2. Test thoroughly before submitting
3. Update documentation references as needed
4. Include rationale for diagram changes in commit messages
5. Consider the audience and purpose of each diagram

For questions about diagram standards or conventions, refer to the main Hydra documentation or ask in the project Discord channel.