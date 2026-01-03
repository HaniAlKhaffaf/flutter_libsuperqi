
import 'flutter_hylid_bridge_platform_interface.dart';

class FlutterHylidBridge {
  Future<String?> getPlatformVersion() {
    return FlutterHylidBridgePlatform.instance.getPlatformVersion();
  }
}
