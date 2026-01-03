// Conditional export based on platform
// This will export the web implementation on web, and stub on other platforms

export 'script_loader_stub.dart'
    if (dart.library.js_interop) 'script_loader_web.dart';
