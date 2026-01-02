import 'dart:js_interop';

extension type _AuthCodeParameters._(JSObject o) implements JSObject {
  external _AuthCodeParameters({
    JSArray<JSString>? scopes,
    JSFunction? success,
    JSFunction? fail,
    JSFunction? complete,
  });
  external JSArray<JSString> get scopes;
  external JSFunction? get success;
  external JSFunction? get fail;
  external JSFunction? get complete;
}

extension type AuthCodeResult._(JSObject o) implements JSObject {
  external AuthCodeResult({
    JSString? authCode,
    JSAny? authErrorScopes,
    JSArray? authSuccessScopes,
  });
  external JSString? get authCode;
  external JSAny? get authErrorScopes;
  external JSArray? get authSuccessScopes;
}

@JS('my.getAuthCode')
external void _fetchAuthCodeFromBridge(_AuthCodeParameters parameters);

void getAuthCode({
  required List<String> scopes,
  void Function(AuthCodeResult result)? success,
  void Function()? fail,
  void Function()? complete,
}) {
  final authParameters = _AuthCodeParameters(
    scopes: scopes.map((s) => s.toJS).toList().toJS,
    success: success?.toJS,
    fail: fail?.toJS,
    complete: complete?.toJS,
  );
  _fetchAuthCodeFromBridge(authParameters);
}
