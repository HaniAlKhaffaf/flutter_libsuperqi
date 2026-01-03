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
