/// A Flutter wrapper for the Hylid Bridge JavaScript SDK.
///
/// This library provides seamless integration with Hylid's payment, authentication,
/// and UI services on web platforms. The Hylid Bridge script is automatically
/// loaded when you use any API - no manual setup required.
///
/// ## Features
///
/// - Payment processing via [tradePay]
/// - OAuth-style authentication via [getAuthCode]
/// - Native-style alerts via [alert]
/// - Automatic script injection on web
/// - Type-safe API with proper Dart types
///
/// ## Usage
///
/// ```dart
/// import 'package:flutter_hylid_bridge/hylid_bridge.dart';
///
/// // Process a payment
/// await tradePay(
///   paymentUrl: 'https://payment-url.com/...',
///   success: (result) => print('Success!'),
/// );
///
/// // Get authorization code
/// await getAuthCode(
///   scopes: ['auth_user'],
///   success: (result) => print('Code: ${result.authCode?.toDart}'),
/// );
///
/// // Show an alert
/// await alert(
///   title: 'Hello',
///   content: 'Welcome to Hylid Bridge!',
/// );
/// ```
///
/// You can also import specific categories:
/// ```dart
/// import 'package:flutter_hylid_bridge/payment.dart'; // Only payment APIs
/// import 'package:flutter_hylid_bridge/auth.dart';    // Only auth APIs
/// import 'package:flutter_hylid_bridge/ui.dart';      // Only UI APIs
/// ```
library;

import 'src/script_loader.dart';

export 'auth.dart';
export 'ui.dart';
export 'payment.dart';

/// Internal class to ensure Hylid Bridge script is loaded automatically
class _HylidBridgeInitializer {
  static final Future<void> _initialization = _initialize();

  static Future<void> _initialize() async {
    await scriptLoader.ensureInitialized();
  }

  /// Get the initialization future (used internally by API methods)
  static Future<void> get ensureInitialized => _initialization;
}

/// Ensures the Hylid Bridge is initialized before use.
///
/// This is called automatically by all API methods, so you typically
/// don't need to call this manually. However, you can call it explicitly
/// if you want to preload the Hylid Bridge script before making API calls.
///
/// Example:
/// ```dart
/// // Optional: Preload the script during app startup
/// await ensureHylidBridgeInitialized();
/// ```
Future<void> ensureHylidBridgeInitialized() => _HylidBridgeInitializer.ensureInitialized;
