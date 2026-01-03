import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libsuperqi_method_channel.dart';

abstract class FlutterLibsuperqiPlatform extends PlatformInterface {
  /// Constructs a FlutterLibsuperqiPlatform.
  FlutterLibsuperqiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibsuperqiPlatform _instance = MethodChannelFlutterLibsuperqi();

  /// The default instance of [FlutterLibsuperqiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibsuperqi].
  static FlutterLibsuperqiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibsuperqiPlatform] when
  /// they register themselves.
  static set instance(FlutterLibsuperqiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
