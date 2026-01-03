/// Authentication APIs for the Hylid Bridge.
///
/// This library provides OAuth-style authentication capabilities through
/// Hylid's authorization system.
///
/// Example:
/// ```dart
/// import 'package:flutter_hylid_bridge/auth.dart';
///
/// await getAuthCode(
///   scopes: ['auth_user', 'auth_profile'],
///   success: (AuthCodeResult result) {
///     final code = result.authCode?.toDart;
///     print('Authorization code: $code');
///   },
/// );
/// ```
library;

export './src/auth/get_auth_code.dart' show getAuthCode, AuthCodeResult;
