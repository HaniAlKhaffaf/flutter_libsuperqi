import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_hylid_bridge_method_channel.dart';

abstract class FlutterHylidBridgePlatform extends PlatformInterface {
  /// Constructs a FlutterHylidBridgePlatform.
  FlutterHylidBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterHylidBridgePlatform _instance = MethodChannelFlutterHylidBridge();

  /// The default instance of [FlutterHylidBridgePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterHylidBridge].
  static FlutterHylidBridgePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterHylidBridgePlatform] when
  /// they register themselves.
  static set instance(FlutterHylidBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
