# Changelog

## [1.5.0] - 2026-01-08

### Added - Phase 2: Advanced Tools & Usage Tracking Integration
- Managed Chat API integration with JWT authentication and tool calling
- Code Intelligence tool for AST parsing and complexity analysis (Python, JavaScript, TypeScript)
- Web Fetch tool for documentation retrieval from 60+ whitelisted domains
- Credits-based usage tracking system with real-time monitoring
- Usage Dashboard with interactive charts, analytics, and export (CSV/JSON)
- Tool Results Panel with intelligent response parsing
- Tool Execution Logs viewer with filtering and debugging capabilities
- SSE streaming support for real-time tool execution progress
- Chat UI enhancements with credits badges and status indicators
- Settings UI for managed API configuration (7 settings)
- 135+ integration tests with 80-95% test coverage
- Comprehensive user documentation (7 guides + deployment docs)

### Technical Improvements
- 21,627 code insertions across 64 files
- 5 new backend services (ManagedChatAPIService, CodeIntelligenceService, WebFetchService, UsageTrackingService, ChatThreadService integration)
- 9 UI component sets with 25+ React components
- Zero production compilation errors
- Complete API specifications and integration guides

### Issues Resolved
- Closes #94 (Phase 2 Epic)
- Closes #95-#108 (14 Phase 2 implementation issues)

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
