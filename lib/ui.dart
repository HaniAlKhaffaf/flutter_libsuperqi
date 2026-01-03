/// UI components for the Hylid Bridge.
///
/// This library provides native-style UI components through Hylid's
/// interface system.
///
/// Example:
/// ```dart
/// import 'package:flutter_libsuperqi/ui.dart';
///
/// await alert(
///   title: 'Success',
///   content: 'Operation completed successfully!',
///   buttonText: 'OK',
/// );
/// ```
library;

export 'dart:js_interop';
export './src/ui/alert.dart' show alert;
