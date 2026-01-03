import 'dart:js_interop';

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

extension type TradePayResult._(JSObject o) implements JSObject {
  external TradePayResult({
    JSString? resultCode,
  });
  external JSString? get resultCode;
}

@JS('my.tradePay')
external void _executeTradePayment(_TradePayParameters parameters);

void tradePay({
  String? paymentUrl,
  void Function(TradePayResult result)? success,
  void Function(TradePayResult result)? fail,
  void Function(TradePayResult result)? complete,
}) {
  final tradePayParameters = _TradePayParameters(
    paymentUrl: paymentUrl?.toJS,
    success: success?.toJS,
    fail: fail?.toJS,
    complete: complete?.toJS,
  );
  _executeTradePayment(tradePayParameters);
}
