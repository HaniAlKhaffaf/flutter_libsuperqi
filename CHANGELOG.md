## 0.0.1

Initial release of flutter_hylid_bridge.

### Features

- Payment processing via `tradePay()` function
- OAuth-style authentication via `getAuthCode()` function
- Native-style alerts via `alert()` function
- Automatic Hylid Bridge script injection on web platforms
- Zero-configuration setup - no manual script tags required
- Cross-platform support with graceful no-op on non-web platforms
- Type-safe API with proper Dart types and JavaScript interop
- Organized API exports (payment, auth, ui) for modular imports
- Comprehensive documentation and examples

### Platform Support

- Web: Full support
- Mobile/Desktop: Stub implementation (no-op)

### Technical Details

- Uses conditional imports for platform-specific implementations
- Singleton pattern for script loading (loads once per session)
- Race condition safe (concurrent calls handled correctly)
- Detects pre-existing scripts to avoid duplicate loading
