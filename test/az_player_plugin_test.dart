import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:az_player_plugin/az_player_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('az_player_plugin');

  setUp(() {
//    channel.setMockMethodCallHandler((MethodCall methodCall) async {
//      return '42';
//    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await AzPlayerPlugin().platformVersion, '42');
//  });
}
