# Hydra Developer Guide

This comprehensive guide covers the development environment setup, build system architecture, and usage patterns for the Hydra project. The project has been converted to a modern pixi-based build system with conda package generation capabilities.

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Project Architecture](#project-architecture)
4. [Build System](#build-system)
5. [Development Workflow](#development-workflow)
6. [Package Structure](#package-structure)
7. [Command-Line Interface](#command-line-interface)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Usage](#advanced-usage)
10. [Contributing](#contributing)

## Overview

The Hydra project is a multi-language functional programming toolkit that has been successfully converted from a traditional build setup to a modern pixi project. This conversion enables unified conda package generation for all language variants using rattler-build.

### Supported Language Variants

- **Java** - Core implementation with complete functionality
- **Python** - Python bindings and implementation (in progress)
- **Haskell** - Pure functional implementation
- **Scala** - JVM-based functional implementation
- **Extensions** - Additional functionality supporting both Java and Haskell

### Key Benefits of the Pixi Setup

1. **Unified Build System** - Single command to build all variants
2. **Modern Recipe Format** - Uses rattler-build v1 specification with pure YAML
3. **Cross-Platform Scripts** - Nushell provides consistent behavior across platforms
4. **Dependency Management** - Pixi handles all build tool dependencies
5. **Environment Isolation** - Clean, reproducible build environments
6. **Package Distribution** - Easy conda package creation and distribution
7. **Developer Experience** - Simple setup with `pixi install`
8. **CI/CD Ready** - Suitable for automated build pipelines

## Quick Start

### Prerequisites

1. **Install pixi**: Follow the installation instructions at [https://pixi.sh](https://pixi.sh)
2. **System Requirements**: Ensure you have sufficient disk space (building all variants requires several GB)

### Basic Setup

```bash
# Clone the repository
git clone https://github.com/CategoricalData/hydra
cd hydra

# Install all build dependencies
pixi install

# Validate the setup
pixi run validate

# Build all packages
pixi run build-all
```

### Environment-Specific Setup

```bash
# Install dependencies for specific environments
pixi install -e java      # Java development environment
pixi install -e python    # Python development environment
pixi install -e haskell   # Haskell development environment
pixi install -e scala     # Scala development environment
pixi install -e all       # Complete multi-language environment
```

## Project Architecture

### Core Configuration Files

- **`pixi.toml`** - Main pixi project configuration
  - Defines project metadata and version (0.12.0)
  - Specifies conda-forge as the primary channel
  - Configures multi-platform support (linux-64, osx-64, osx-arm64, win-64)
  - Sets up feature-based environments for different language toolchains
  - Defines build tasks for all variants

- **`recipes/`** directory containing rattler-build v1 recipes with embedded nushell scripts

### Package Hierarchy

The project generates several conda packages:

#### Individual Language Packages

1. **hydra-java** (v0.12.0)
   - Built with Gradle via nushell script
   - Requires OpenJDK 11+ and nushell
   - Generates JAR files and wrapper scripts
   - Installs to `$PREFIX/lib/hydra-java/`

2. **hydra-python** (v0.10.0)
   - Built with pip + hatchling via nushell script
   - Requires Python 3.12+ and nushell
   - Standard Python package installation
   - Uses existing `pyproject.toml`

3. **hydra-haskell** (v0.12.0)
   - Built with Stack via nushell script
   - Requires GHC 9.4+, Stack, and nushell
   - Generates libraries and executables
   - Installs to `$PREFIX/lib/hydra-haskell/`

4. **hydra-scala** (v0.1.0)
   - Built with SBT via nushell script
   - Requires OpenJDK 11+, SBT, and nushell
   - Generates JAR files and wrapper scripts
   - Installs to `$PREFIX/lib/hydra-scala/`

5. **hydra-ext** (v0.12.0)
   - Hybrid Java/Haskell build via nushell script
   - Supports both Gradle and Stack builds
   - Contains additional functionality
   - Includes data files and extensions

#### Meta-Package

The main **hydra** package (v0.12.0) is a meta-package that:
- Depends on all individual variant packages
- Provides unified command-line interface
- Includes comprehensive wrapper script (`hydra` command)
- Supports multi-variant usage patterns

## Build System

### Available Environments

The pixi project defines several environments for different use cases:

- **default** - Minimal environment with rattler-build and nushell
- **java** - Java development environment (OpenJDK 11+, Gradle, nushell)
- **python** - Python development environment (Python 3.12+, nushell)
- **haskell** - Haskell development environment (GHC 9.4+, Stack, nushell)
- **scala** - Scala development environment (OpenJDK 11+, SBT, nushell)
- **all** - Complete environment with all language toolchains

### Build Tasks

```bash
# Build all packages
pixi run build-all

# Build individual packages
pixi run build-java      # Build Java components
pixi run build-python    # Build Python components
pixi run build-haskell   # Build Haskell components
pixi run build-scala     # Build Scala components
pixi run build-ext       # Build extensions

# Utility tasks
pixi run clean           # Clean build artifacts
pixi run validate        # Validate setup
```

### Using Environments

```bash
# Activate an environment
pixi shell -e java
pixi shell -e python
pixi shell -e haskell
pixi shell -e scala
pixi shell -e all

# Run commands in specific environments
pixi run -e java build-java
pixi run -e python build-python
pixi run -e haskell build-haskell
pixi run -e scala build-scala
```

## Development Workflow

### Making Changes

1. **Modify source code** in the appropriate variant directory
2. **Update version numbers** in both `pixi.toml` and recipe files if needed
3. **Test the build** with the specific variant
4. **Build and test** the complete package

### Testing Changes

```bash
# Test individual components
pixi run -e java build-java
pixi run -e python build-python
pixi run -e haskell build-haskell
pixi run -e scala build-scala

# Test complete build
pixi run build-all

# Install and test locally
conda install -c ./conda-bld hydra
```

### Integration with Existing Build Systems

The pixi setup works alongside existing build configurations:
- Preserves existing `build.gradle` files
- Uses existing `pyproject.toml` for Python
- Leverages existing `stack.yaml` for Haskell
- Utilizes existing `build.sbt` for Scala

No changes were made to the core language implementations - the pixi layer provides conda packaging on top of existing build systems via nushell scripts that call the appropriate build tools.

## Package Structure

### Recipe Organization

```
recipes/
├── recipe.yaml              # Main meta-package (with embedded nushell script)
├── hydra-wrapper.sh         # Main hydra command wrapper script
├── jvm-wrapper.sh           # Unified JVM wrapper for main package (Java & Scala)
├── hydra-java/
│   ├── recipe.yaml          # Java package recipe (with embedded nushell script)
│   └── wrapper.sh           # Java package wrapper script
├── hydra-python/
│   └── recipe.yaml          # Python package recipe (with embedded nushell script)
├── hydra-haskell/
│   └── recipe.yaml          # Haskell package recipe (with embedded nushell script)
├── hydra-scala/
│   ├── recipe.yaml          # Scala package recipe (with embedded nushell script)
│   └── wrapper.sh           # Scala package wrapper script
└── hydra-ext/
    └── recipe.yaml          # Extensions package recipe (with embedded nushell script)
```

### Modern Recipe Format

Uses rattler-build v1 specification with these improvements:
- **Pure YAML format** - No external bash/batch files
- **Embedded nushell scripts** - Cross-platform build logic
- **Proper Jinja syntax** - `${{ variable }}` instead of `{{ variable }}`
- **Updated metadata fields** - `homepage` instead of `home`
- **Enhanced validation** - JSON schema support
- **V1 test format** - `tests:` instead of `test:`

### Build Process Details

All recipes use **nushell scripts** embedded directly in the `recipe.yaml` files. This provides:
- Pure YAML format (no separate bash/batch files)
- Cross-platform compatibility through nushell
- Better integration with rattler-build
- Improved error handling and logging
- Separate wrapper script files for better maintainability
- Unified JVM wrapper reduces duplication for main package

### Cross-Platform Support

Recipes are configured for multiple platforms:
- Linux x86_64 (`linux-64`)
- macOS Intel (`osx-64`)
- macOS Apple Silicon (`osx-arm64`)
- Windows x86_64 (`win-64`)

## Command-Line Interface

After installation, users can access Hydra through multiple interfaces:

### Multi-Variant Wrapper

```bash
# Main hydra command (multi-variant wrapper)
hydra --help
hydra java --help
hydra python -c "import hydra; print('Hydra Python loaded')"
hydra haskell --version
hydra scala --version
```

### Direct Variant Access

```bash
# Direct variant commands
hydra-java --help
hydra-scala --help
# Plus any generated Haskell executables
```

### Language-Specific APIs

#### Python API

```python
import hydra
# Use Hydra Python implementation
```

#### Haskell Library

```haskell
import Hydra.Core
-- Use Hydra Haskell implementation
```

## Troubleshooting

### Common Build Issues

#### Nushell Script Issues
- Ensure nushell is available (`pixi list | grep nushell`)
- Check nushell syntax in recipe files
- Verify environment variables are properly referenced (`$env.PREFIX`, `$env.SRC_DIR`)

#### Java Build Failures
- Ensure OpenJDK 11+ is available
- Check that Gradle can resolve dependencies
- Verify network connectivity for dependency downloads
- Check nushell file operations (glob patterns, path operations)

#### Python Build Failures
- Ensure Python 3.12+ is available
- Check that pip can install dependencies
- Verify pyproject.toml is correctly configured

#### Haskell Build Failures
- Ensure GHC 9.4+ is available
- Check Stack configuration and resolver version
- Verify system GHC can be used by Stack
- Check nushell path operations for Stack artifacts

#### Scala Build Failures
- Ensure OpenJDK 11+ is available
- Check SBT configuration and dependencies
- Verify Ivy/Maven repository access
- Check nushell regex parsing for dependency classpath

### Environment Issues

#### Missing Dependencies
```bash
pixi install -e all  # Install all dependencies
```

#### Version Conflicts
- Check `pixi.toml` for version constraints
- Update channel priorities if needed

#### Build Space Issues
- Ensure sufficient disk space (5+ GB recommended)
- Clean previous builds: `pixi run clean`

#### Recipe Format Issues
- Verify recipes use rattler-build v1 format (not conda-build meta.yaml)
- Check Jinja variable syntax: `${{ variable }}` not `{{ variable }}`
- Ensure `about.homepage` is used instead of `about.home`
- Use `tests:` section instead of `test:`
- Use `repository:` and `documentation:` instead of `dev_url:` and `doc_url:`
- Validate embedded nushell scripts for syntax errors
- Check that wrapper script files exist and are executable

### Getting Help

- Check the main [Hydra repository](https://github.com/CategoricalData/hydra)
- Join the [LambdaGraph Discord](https://bit.ly/lg-discord) server
- Review individual variant documentation in their respective subdirectories

## Advanced Usage

### Custom Build Options

You can customize builds by modifying the nushell scripts in recipe files or passing environment variables:

```bash
# Set custom build options
export GRADLE_OPTS="-Xmx4g"
pixi run build-java

# Use different Stack resolver
export STACK_YAML="stack-custom.yaml"
pixi run build-haskell
```

### Recipe Format Details

The project uses rattler-build v1 recipe format with these key features:

- **Pure YAML**: No Jinja comments or external script files
- **Embedded nushell scripts**: Build logic is directly in `recipe.yaml` files
- **Separate wrapper scripts**: Bash wrapper scripts in dedicated files for maintainability
- **Modern syntax**: `${{ variable }}` for Jinja interpolation
- **Updated metadata**: `homepage` instead of `home`, `repository`/`documentation` for URLs
- **V1 test format**: `tests:` section with proper script/python/imports structure
- **Cross-platform**: Nushell provides consistent behavior across platforms

### Publishing Packages

After building, packages can be uploaded to conda channels:

```bash
# Upload to conda-forge (requires maintainer access)
anaconda upload conda-bld/linux-64/hydra-*.tar.bz2

# Upload to personal channel
anaconda upload -u yourusername conda-bld/linux-64/hydra-*.tar.bz2
```

## Contributing

When contributing to the Hydra project:

### Code Changes
1. **Maintain consistency** across recipe files
2. **Update version numbers** in sync across all recipes
3. **Test all variants** before submitting changes
4. **Document any new dependencies** or requirements
5. **Update documentation** if adding new features or changing workflows

### Testing Contributions
```bash
# Validate setup
pixi run validate

# Test individual components
pixi run -e java build-java
pixi run -e python build-python
pixi run -e haskell build-haskell
pixi run -e scala build-scala

# Test complete build
pixi run build-all
```

### Pixi Configuration Guidelines

When modifying the pixi configuration:

1. **Maintain environment separation** - Each language should have its own environment
2. **Use consistent versioning** - Keep versions synchronized across recipes
3. **Test cross-platform** - Verify changes work on different operating systems
4. **Document dependencies** - Update this guide when adding new requirements
5. **Validate recipes** - Ensure rattler-build v1 format compliance

---

For more information about Hydra's theoretical foundations and language-specific implementation details, see the main [README.md](../README.md) file and the individual variant documentation in their respective subdirectories.