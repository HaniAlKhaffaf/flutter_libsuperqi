import 'dart:js_interop';
import '../script_loader.dart';

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

/// Result object returned from authorization code requests.
///
/// Contains the authorization code and information about which scopes
/// were granted or denied.
extension type AuthCodeResult._(JSObject o) implements JSObject {
  external AuthCodeResult({
    JSString? authCode,
    JSAny? authErrorScopes,
    JSArray? authSuccessScopes,
  });

  /// The authorization code returned on successful authentication.
  /// Use `.toDart` to convert to a Dart String.
  external JSString? get authCode;

  /// Scopes that failed authorization.
  external JSAny? get authErrorScopes;

  /// Scopes that were successfully authorized.
  external JSArray? get authSuccessScopes;
}

@JS('my.getAuthCode')
external void _fetchAuthCodeFromBridge(_AuthCodeParameters parameters);

/// Requests an authorization code with the specified scopes.
///
/// This function initiates an OAuth-style authorization flow through the
/// Hylid Bridge. The user will be prompted to authorize the requested scopes,
/// and an authorization code will be returned on success.
///
/// Example:
/// ```dart
/// await getAuthCode(
///   scopes: ['auth_user', 'auth_profile'],
///   success: (AuthCodeResult result) {
///     final code = result.authCode?.toDart;
///     print('Auth code: $code');
///     // Send code to your backend to exchange for access token
///   },
///   fail: () {
///     print('User denied authorization');
///   },
/// );
/// ```
///
/// Parameters:
/// - [scopes]: List of authorization scopes to request (e.g., 'auth_user', 'auth_profile').
/// - [success]: Called when authorization succeeds with the auth code.
/// - [fail]: Called when authorization fails or is denied.
/// - [complete]: Called when the authorization flow completes (success or fail).
Future<void> getAuthCode({
  required List<String> scopes,
  void Function(AuthCodeResult result)? success,
  void Function()? fail,
  void Function()? complete,
}) async {
  // Ensure the Hylid Bridge script is loaded before calling
  await scriptLoader.ensureInitialized();

  final authParameters = _AuthCodeParameters(
    scopes: scopes.map((s) => s.toJS).toList().toJS,
    success: success?.toJS,
    fail: fail?.toJS,
    complete: complete?.toJS,
  );
  _fetchAuthCodeFromBridge(authParameters);
}
