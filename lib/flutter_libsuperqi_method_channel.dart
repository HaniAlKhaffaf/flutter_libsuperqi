import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libsuperqi_platform_interface.dart';

/// An implementation of [FlutterLibsuperqiPlatform] that uses method channels.
class MethodChannelFlutterLibsuperqi extends FlutterLibsuperqiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libsuperqi');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
