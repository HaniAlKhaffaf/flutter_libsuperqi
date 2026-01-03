import 'dart:js_interop';
import '../script_loader.dart';

extension type _TradePayParameters._(JSObject o) implements JSObject {
  external _TradePayParameters({
    JSString? paymentUrl,
    JSFunction? success,
    JSFunction? fail,
    JSFunction? complete,
  });
  external JSString? get paymentUrl;
  external JSFunction? get success;
  external JSFunction? get fail;
  external JSFunction? get complete;
}

/// Result object returned from trade pay operations.
///
/// Contains the result code indicating the payment status.
extension type TradePayResult._(JSObject o) implements JSObject {
  external TradePayResult({
    JSString? resultCode,
  });

  /// The result code from the payment operation.
  /// Use `.toDart` to convert to a Dart String.
  external JSString? get resultCode;
}

@JS('my.tradePay')
external void _executeTradePayment(_TradePayParameters parameters);

/// Initiates a payment transaction using Hylid's trade pay system.
///
/// This function opens the Hylid payment interface for the user to complete
/// a payment transaction. The payment flow is handled by the Hylid Bridge,
/// and callbacks are invoked based on the payment result.
///
/// Example:
/// ```dart
/// await tradePay(
///   paymentUrl: 'https://payment-gateway.com/pay?order=12345',
///   success: (TradePayResult result) {
///     print('Payment successful: ${result.resultCode?.toDart}');
///   },
///   fail: (TradePayResult result) {
///     print('Payment failed: ${result.resultCode?.toDart}');
///   },
///   complete: (TradePayResult result) {
///     print('Payment flow completed');
///   },
/// );
/// ```
///
/// Parameters:
/// - [paymentUrl]: The payment URL provided by your backend server.
/// - [success]: Called when the payment completes successfully.
/// - [fail]: Called when the payment fails.
/// - [complete]: Called when the payment flow completes (success or fail).
Future<void> tradePay({
  String? paymentUrl,
  void Function(TradePayResult result)? success,
  void Function(TradePayResult result)? fail,
  void Function(TradePayResult result)? complete,
}) async {
  // Ensure the Hylid Bridge script is loaded before calling
  await scriptLoader.ensureInitialized();

  final tradePayParameters = _TradePayParameters(
    paymentUrl: paymentUrl?.toJS,
    success: success?.toJS,
    fail: fail?.toJS,
    complete: complete?.toJS,
  );
  _executeTradePayment(tradePayParameters);
}
