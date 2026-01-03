// Export all categories
// Users can import from this file to get all APIs,
// or import specific category files (auth.dart, ui.dart, payment.dart) for better organization

import 'src/script_loader.dart';

export 'auth.dart';
export 'ui.dart';
export 'payment.dart';

/// Internal class to ensure Hylid Bridge script is loaded automatically
class _HylidBridgeInitializer {
  static final Future<void> _initialization = _initialize();

  static Future<void> _initialize() async {
    await scriptLoader.ensureInitialized();
  }

  /// Get the initialization future (used internally by API methods)
  static Future<void> get ensureInitialized => _initialization;
}

/// Ensures the Hylid Bridge is initialized before use
/// This is called automatically when you use any API method
Future<void> ensureHylidBridgeInitialized() => _HylidBridgeInitializer.ensureInitialized;
