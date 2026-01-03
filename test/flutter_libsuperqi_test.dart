import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libsuperqi/flutter_libsuperqi.dart';
import 'package:flutter_libsuperqi/flutter_libsuperqi_platform_interface.dart';
import 'package:flutter_libsuperqi/flutter_libsuperqi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLibsuperqiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLibsuperqiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLibsuperqiPlatform initialPlatform = FlutterLibsuperqiPlatform.instance;

  test('$MethodChannelFlutterLibsuperqi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibsuperqi>());
  });

  test('getPlatformVersion', () async {
    FlutterLibsuperqi flutterLibsuperqiPlugin = FlutterLibsuperqi();
    MockFlutterLibsuperqiPlatform fakePlatform = MockFlutterLibsuperqiPlatform();
    FlutterLibsuperqiPlatform.instance = fakePlatform;

    expect(await flutterLibsuperqiPlugin.getPlatformVersion(), '42');
  });
}
