# Changelog

## [Unreleased] - 2026-01-01

### Fixed
- Fixed NULL values in product.json that prevented builds ([#67](https://github.com/AINative-Studio/AINativeStudio-IDE/issues/67))
- Added build-time commit hash injection ([#68](https://github.com/AINative-Studio/AINativeStudio-IDE/issues/68))
- Installed create-dmg dependency in macOS workflow to prevent npx download failures ([#69](https://github.com/AINative-Studio/AINativeStudio-IDE/issues/69))
- Added update URLs for auto-update system
- Fixed product.json merge logic in prepare_vscode.sh

### Added
- Build-time commit hash injection script (inject-commit.js)
- Precompile hook to ensure commit hash is set before builds
- Comprehensive build documentation in README.md
- Troubleshooting guide for common build issues

### Changed
- product.json now includes version, quality, commit, updateUrl fields
- prepare_vscode.sh now injects commit hash after product.json merge
- GitHub Actions workflow now pre-installs create-dmg globally
