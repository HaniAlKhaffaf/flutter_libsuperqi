import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hylid_bridge/flutter_hylid_bridge.dart';
import 'package:flutter_hylid_bridge/flutter_hylid_bridge_platform_interface.dart';
import 'package:flutter_hylid_bridge/flutter_hylid_bridge_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterHylidBridgePlatform
    with MockPlatformInterfaceMixin
    implements FlutterHylidBridgePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterHylidBridgePlatform initialPlatform = FlutterHylidBridgePlatform.instance;

  test('$MethodChannelFlutterHylidBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterHylidBridge>());
  });

  test('getPlatformVersion', () async {
    FlutterHylidBridge flutterHylidBridgePlugin = FlutterHylidBridge();
    MockFlutterHylidBridgePlatform fakePlatform = MockFlutterHylidBridgePlatform();
    FlutterHylidBridgePlatform.instance = fakePlatform;

    expect(await flutterHylidBridgePlugin.getPlatformVersion(), '42');
  });
}
