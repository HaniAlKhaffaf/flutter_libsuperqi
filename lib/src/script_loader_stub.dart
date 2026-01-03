import 'dart:async';

/// Stub implementation for non-web platforms
/// This does nothing since the Hylid Bridge is only needed on web
class ScriptLoader {
  static final ScriptLoader _instance = ScriptLoader._internal();
  factory ScriptLoader() => _instance;
  ScriptLoader._internal();

  /// No-op for non-web platforms
  Future<void> ensureInitialized() async {
    // Nothing to do on non-web platforms
    return;
  }
}

/// Gets the shared ScriptLoader instance
ScriptLoader get scriptLoader => ScriptLoader();
