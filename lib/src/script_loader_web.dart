import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('my')
external JSObject? get _hylidBridgeGlobal;

/// Manages the loading of the Hylid Bridge JavaScript library
class ScriptLoader {
  static final ScriptLoader _instance = ScriptLoader._internal();
  factory ScriptLoader() => _instance;
  ScriptLoader._internal();

  static const String _scriptUrl =
      'https://cdn.marmot-cloud.com/npm/hylid-bridge/2.10.0/index.js';
  static const String _scriptId = 'hylid-bridge-script';

  Completer<void>? _loadCompleter;
  bool _isLoaded = false;

  /// Ensures the Hylid Bridge script is loaded
  Future<void> ensureInitialized() async {
    // If already loaded, return immediately
    if (_isLoaded) {
      return;
    }

    // If currently loading, wait for existing load to complete
    if (_loadCompleter != null) {
      return _loadCompleter!.future;
    }

    // Start loading
    _loadCompleter = Completer<void>();

    try {
      // Check if script already exists in DOM (manually added by user)
      final existingScript = web.document.getElementById(_scriptId);
      if (existingScript != null) {
        _isLoaded = true;
        _loadCompleter!.complete();
        return;
      }

      // Check if 'my' object already exists (script loaded elsewhere)
      if (_isHylidBridgeAvailable()) {
        _isLoaded = true;
        _loadCompleter!.complete();
        return;
      }

      // Create and inject script tag
      final script = web.document.createElement('script') as web.HTMLScriptElement;
      script.id = _scriptId;
      script.src = _scriptUrl;
      script.type = 'text/javascript';

      // Set up load handlers
      script.onload = (web.Event event) {
        _isLoaded = true;
        _loadCompleter!.complete();
      }.toJS;

      script.onerror = (web.Event event) {
        final error = Exception('Failed to load Hylid Bridge script from $_scriptUrl');
        _loadCompleter!.completeError(error);
        _loadCompleter = null;
      }.toJS;

      // Inject into DOM
      web.document.head!.appendChild(script);
    } catch (e) {
      _loadCompleter!.completeError(e);
      _loadCompleter = null;
      rethrow;
    }

    return _loadCompleter!.future;
  }

  /// Checks if the Hylid Bridge global object is available
  bool _isHylidBridgeAvailable() {
    try {
      final my = _hylidBridgeGlobal;
      return my != null;
    } catch (e) {
      return false;
    }
  }
}

/// Gets the shared ScriptLoader instance
ScriptLoader get scriptLoader => ScriptLoader();
