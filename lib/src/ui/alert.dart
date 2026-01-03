import 'dart:js_interop';
import '../script_loader.dart';

extension type _AlertOptions._(JSObject o) implements JSObject {
  external _AlertOptions({
    JSString? title,
    JSString? content,
    JSString? buttonText,
    JSFunction? success,
    JSFunction? fail,
    JSFunction? complete,
  });
  external JSString? get title;
  external JSString? get content;
  external JSString? get buttonText;
  external JSFunction? get success;
  external JSFunction? get fail;
  external JSFunction? get complete;
}

@JS('my.alert')
external void _displayNativeAlert(_AlertOptions options);

/// Displays a native-style alert dialog.
///
/// Shows an alert dialog with the specified title, content, and button text.
/// The alert is displayed using the Hylid Bridge's native UI components,
/// which match the platform's look and feel.
///
/// Example:
/// ```dart
/// await alert(
///   title: 'Payment Complete',
///   content: 'Your payment has been processed successfully.',
///   buttonText: 'OK',
///   success: () {
///     print('User dismissed the alert');
///   },
/// );
/// ```
///
/// Parameters:
/// - [title]: The title of the alert dialog.
/// - [content]: The main message to display in the alert.
/// - [buttonText]: The text for the dismiss button (default: "OK").
/// - [success]: Called when the user dismisses the alert.
/// - [fail]: Called if the alert fails to display.
/// - [complete]: Called when the alert flow completes.
Future<void> alert({
  String? title,
  String? content,
  String? buttonText,
  void Function()? success,
  void Function()? fail,
  void Function()? complete,
}) async {
  // Ensure the Hylid Bridge script is loaded before calling
  await scriptLoader.ensureInitialized();

  final alertOptions = _AlertOptions(
    title: title?.toJS,
    content: content?.toJS,
    buttonText: buttonText?.toJS,
    success: success?.toJS,
    fail: fail?.toJS,
    complete: complete?.toJS,
  );
  _displayNativeAlert(alertOptions);
}
