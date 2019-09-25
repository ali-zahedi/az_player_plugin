import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AzPlayerPlugin {
  static const MethodChannel _channel = const MethodChannel('az_player_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Widget getPlayerView() {
    Map<String, String> creationParams = {};
    final width = 100.toDouble();
    final height = 200.toDouble();
    creationParams['width'] = width.toString();
    creationParams['height'] = height.toString();

    return SizedBox(
      width: width,
      height: height,
      child: UiKitView(
        viewType: 'PlayerView',
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
      ),
    );
  }
}
