/// Authentication APIs for the Hylid Bridge.
///
/// This library provides OAuth-style authentication capabilities through
/// Hylid's authorization system.
///
/// Example:
/// ```dart
/// import 'package:flutter_libsuperqi/auth.dart';
///
/// await getAuthCode(
///   scopes: ['auth_base', 'USER_ID'],
///   success: (AuthCodeResult result) {
///     final code = result.authCode?.toDart;
///     print('Authorization code: $code');
///   },
/// );
/// ```
library;

export './src/auth/get_auth_code.dart' show getAuthCode, AuthCodeResult;
