import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:az_player_plugin/az_player_plugin.dart';

class AzPlayerPlugin implements InterfacePlayer {
  static const AzPlayerPlugin _instance = const AzPlayerPlugin._();
  final MethodChannel _channel = const MethodChannel('az_player_plugin');

  const AzPlayerPlugin._();

  factory AzPlayerPlugin() {
    return AzPlayerPlugin._instance;
  }

  @override
  Future<InterfaceFile> get currentFile async{
    final num pk = await _channel.invokeMethod('currentFile');
    throw UnimplementedError();
//    return result;
  }

  @override
  Future<num> get duration async{
    final num result = await _channel.invokeMethod('duration');
    return result;
  }

  @override
  Future<num> get currentTime async{
    final num result = await _channel.invokeMethod('currentTime');
    return result;
  }

  @override
  Future<bool> get isPlaying async{
    final bool isPlaying = await _channel.invokeMethod('isPlaying');
    return isPlaying;
  }

  @override
  Future<num> get secondsLeft async {
    final num result = await _channel.invokeMethod('secondsLeft');
    return result;
  }

  @override
  Widget getPlayerView({num width = 300, num height = 300}) {
    Map<String, String> creationParams = {};
    final w = width.toDouble();
    final h = height.toDouble();
    creationParams['width'] = w.toString();
    creationParams['height'] = h.toString();

    return SizedBox(
      width: w,
      height: h,
      child: UiKitView(
        viewType: 'PlayerView',
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
      ),
    );
  }

  @override
  Future<bool> addFileToPlayList(InterfaceFile file) async {
  
    final bool result = await _channel.invokeMethod('addFileToPlayList', file.toJson());
    return result;
  }

  @override
  Future<bool> addFilesToPlayList(List<InterfaceFile> files) async{
    List<Map<String, dynamic>> filesJson = [];
    files.forEach((elem){
      filesJson.add(elem.toJson());
    });
    final bool result = await _channel.invokeMethod('addFileToPlayList', filesJson);
    return result;
  }

  @override
  Future<bool> changeTime(num toSecond) async{
    final bool result = await _channel.invokeMethod('changeTime', toSecond);
    return result;
  }

  @override
  Future<bool> emptyPlayList() async{
    final bool result = await _channel.invokeMethod('emptyPlayList');
    return result;
  }

  @override
  Future<List<InterfaceFile>> getPlayList() {
    throw UnimplementedError();
  }

  @override
  Future<bool> next() async{
    final bool result = await _channel.invokeMethod('next');
    return result;
  }

  @override
  Future<bool> pause() async{
    final bool result = await _channel.invokeMethod('pause');
    return result;
  }

  @override
  Future<bool> play() async{
    final bool result = await _channel.invokeMethod('play');
    return result;
  }

  @override
  Future<bool> playWithFile(InterfaceFile file) async {
    final bool result = await _channel.invokeMethod('playWithFile', file.toJson());
    return result;
  }

  @override
  Future<bool> previous() async {
    final bool result = await _channel.invokeMethod('previous');
    return result;
  }

  @override
  Future<bool> removeFromPlayList(InterfaceFile file) async{
    final bool result = await _channel.invokeMethod('playWithFile', file.toJson());
    return result;
  }

  @override
  Future<bool> stop() async{
    final bool result = await _channel.invokeMethod('stop');
    return result;
  }
}
