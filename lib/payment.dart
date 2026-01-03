/// Payment APIs for the Hylid Bridge.
///
/// This library provides payment processing capabilities through Hylid's
/// trade pay system.
///
/// Example:
/// ```dart
/// import 'package:flutter_hylid_bridge/payment.dart';
///
/// await tradePay(
///   paymentUrl: 'https://payment-gateway.com/pay?order=123',
///   success: (TradePayResult result) {
///     print('Payment successful!');
///   },
/// );
/// ```
library;

export './src/payment/trade_pay.dart' show tradePay, TradePayResult;
