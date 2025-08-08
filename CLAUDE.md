# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the AINative Studio Builder - a fork of VSCodium focused on building AINative Studio (a VSCode-based editor). The project serves as a build pipeline that:

- Builds AINative Studio binaries (.dmg, .zip, etc.) via GitHub Actions
- Applies patches to remove telemetry and customize branding
- Handles auto-update logic for the AINative Studio application
- Maintains separate stable and insider builds

The codebase is primarily a collection of shell scripts, patches, and configuration files that orchestrate the build process of VSCode into AINative Studio.

## Core Architecture

### Build System
- **Main build script**: `dev/build.sh` - Primary development build script with flags for different build types
- **CI build script**: `build.sh` - Production build script used by GitHub Actions
- **Patch system**: `patches/` directory contains all modifications applied to VSCode source
- **Version management**: `version.sh` handles version detection and BUILD_SOURCEVERSION generation

### Key Components
- `patches/` - Contains all .patch files that modify VSCode source code
- `src/` - Contains custom resources (icons, branding) for stable and insider builds
- `dev/` - Development scripts and utilities
- `docs/` - Build documentation and troubleshooting guides
- `stores/` - Package configurations for Snap and Winget stores

## Common Development Commands

### Building AINative Studio
```bash
# Full build (default)
./dev/build.sh

# Insider build
./dev/build.sh -i

# Build with latest VSCode version
./dev/build.sh -l

# Skip building, only generate packages/assets
./dev/build.sh -o -p

# Skip source retrieval (use existing vscode dir)
./dev/build.sh -s
```

### Build Flags
- `-i`: Build the Insiders version
- `-l`: Build with latest version of Visual Studio Code
- `-o`: Skip the build step
- `-p`: Generate the packages/assets/installers  
- `-s`: Do not retrieve VSCode source code

### Patch Management
```bash
# Update patches after VSCode changes
./dev/update_patches.sh

# Apply patches manually
git apply --reject ../patches/<patch-name>.patch
```

### Dependencies
- Node.js 20.14+
- Python 3.11
- Platform-specific build tools (see docs/howto-build.md)

## Build Process Flow

1. **Source Preparation** (`get_repo.sh`): Downloads VSCode source
2. **Version Detection** (`version.sh`): Determines build version and commit
3. **Patch Application**: Applies all .patch files from patches/ directory
4. **Build Execution** (`build.sh`): Compiles VSCode with modifications
5. **Asset Preparation** (`prepare_assets.sh`): Packages final binaries

## Key Environment Variables

- `APP_NAME`: "AINative Studio" (the display name)
- `BINARY_NAME`: "codium" (executable name) 
- `GH_REPO_PATH`: "AINativeStudio-IDE/ainative-studio"
- `ORG_NAME`: "AINative-Studio"
- `VSCODE_QUALITY`: "stable" or "insider"
- `VSCODE_ARCH`: Target architecture (x64, arm64, etc.)

## Important Files

- `product.json`: VSCode product configuration
- `utils.sh`: Common utility functions for string replacement and patch application
- `prepare_vscode.sh`: Prepares VSCode source with patches
- `build_cli.sh`: Builds command-line interface

## Branding and Customization

All AINative Studio branding is handled through:
- Patch files that replace Microsoft/VSCode references
- Custom icons and resources in `src/stable/` and `src/insider/`
- String replacements in `utils.sh` using placeholder patterns like `!!APP_NAME!!`

## Testing and Validation

The build process includes validation steps but no formal test suite. Validation occurs through:
- Successful patch application
- Successful compilation of modified VSCode
- Manual testing of generated binaries

## GitHub Actions Integration

The repository is designed to work with GitHub Actions workflows that:
- Build binaries for multiple platforms
- Store assets in release repositories
- Update version tracking for auto-updates