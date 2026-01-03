
import 'flutter_libsuperqi_platform_interface.dart';

class FlutterLibsuperqi {
  Future<String?> getPlatformVersion() {
    return FlutterLibsuperqiPlatform.instance.getPlatformVersion();
  }
}
