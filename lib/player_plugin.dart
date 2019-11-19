import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:az_player_plugin/az_player_plugin.dart';

class AzPlayerPlugin implements InterfacePlayer {
  static AzPlayerPlugin _instance = AzPlayerPlugin._();
  final MethodChannel _channel = const MethodChannel('az_player_plugin');

  AzPlayerPlugin._();

  factory AzPlayerPlugin() {
    return AzPlayerPlugin._instance;
  }

  LinkedHashSet<File> _files = new LinkedHashSet<File>();

  @override
  Future<InterfaceFile> get currentFile async {
    final num pk = await _channel.invokeMethod('currentFile');
    File file;
    for (var i = 0; i < this._files.length; i++) {
      if (this._files.elementAt(i).pk == pk) {
        file = this._files.elementAt(i);
        break;
      }
    }
    return file;
  }

  @override
  Future<num> get duration async {
    final num result = await _channel.invokeMethod('duration');
    return result;
  }

  @override
  Future<num> get currentTime async {
    final num result = await _channel.invokeMethod('currentTime');
    return result;
  }

  @override
  Future<bool> get isPlaying async {
    final bool isPlaying = await _channel.invokeMethod('isPlaying');
    return isPlaying;
  }

  @override
  Future<num> get secondsLeft async {
    final num result = await _channel.invokeMethod('secondsLeft');
    return result;
  }

  @override
  Widget getPlayerView(
      {@required BuildContext context, num width = 0, num height = 0, bool isProtectAspectRation = true}) {
    assert(context != null);
    assert(width != null);
    assert(height != null);
    assert(isProtectAspectRation != null);
    
    Map<String, String> creationParams = {};

    double w = width.toDouble();
    double h = height.toDouble();
    double division = (w / 16) / (h / 9);

    if (division >= 1) {
      // the width bigger than height
      w = w / division;
    } else {
      // the height bigger than width
      h = h * division;
    }
    creationParams['width'] = w.toString();
    creationParams['height'] = h.toString();

    Widget playerView;

    if (defaultTargetPlatform == TargetPlatform.android) {
      playerView = AndroidView(
        viewType: 'PlayerView',
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      playerView = UiKitView(
        viewType: 'PlayerView',
        creationParams: creationParams,
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      playerView = Container();
    }

    Map<String, dynamic> size = Map();
    size['width'] = w * _calculatePixelRatio(context);
    size['height'] = h * _calculatePixelRatio(context);
    _channel.invokeMethod('changeScreenSize', size);
    
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      child: Center(
        child: Container(
          width: w,
          height: h,
          child: playerView,
        ),
      ),
    );
  }

  @override
  Future<bool> addFileToPlayList(InterfaceFile file) async {
    final bool result =
        await _channel.invokeMethod('addFileToPlayList', file.toJson());
    this._files.add(file);
    return result;
  }

  @override
  Future<bool> addFilesToPlayList(List<InterfaceFile> files) async {
    List<Map<String, dynamic>> filesJson = [];
    files.forEach((elem) {
      filesJson.add(elem.toJson());
      this._files.add(elem);
    });
    final bool result =
        await _channel.invokeMethod('addFilesToPlayList', filesJson);
    ;
    return result;
  }

  @override
  Future<bool> changeTime(num toSecond) async {
    final bool result = await _channel.invokeMethod('changeTime', toSecond);
    return result;
  }

  @override
  Future<bool> emptyPlayList() async {
    final bool result = await _channel.invokeMethod('emptyPlayList');
    this._files.clear();
    return result;
  }

  @override
  Future<List<InterfaceFile>> getPlayList() async {
    return this._files.toList();
  }

  @override
  Future<bool> next() async {
    final bool result = await _channel.invokeMethod('next');
    return result;
  }

  @override
  Future<bool> pause() async {
    final bool result = await _channel.invokeMethod('pause');
    return result;
  }

  @override
  Future<bool> play() async {
    final bool result = await _channel.invokeMethod('play');
    return result;
  }

  @override
  Future<bool> playWithFile(InterfaceFile file) async {
    this._files.add(file);
    final bool result =
        await _channel.invokeMethod('playWithFile', file.toJson());
    return result;
  }

  @override
  Future<bool> previous() async {
    final bool result = await _channel.invokeMethod('previous');
    return result;
  }

  @override
  Future<bool> removeFromPlayList(InterfaceFile file) async {
    final bool result =
        await _channel.invokeMethod('removeFromPlayList', file.toJson());
    this._files.removeWhere((value) => value.pk == file.pk);
    return result;
  }

  @override
  Future<bool> stop() async {
    final bool result = await _channel.invokeMethod('stop');
    return result;
  }

  @override
  Future<bool> fastBackward() async {
    final bool result = await _channel.invokeMethod('fastBackward');
    return result;
  }

  @override
  Future<bool> fastForward() async {
    final bool result = await _channel.invokeMethod('fastForward');
    return result;
  }

  @override
  Future<bool> setImagePlaceHolder(String path) async {
    final bool result =
        await _channel.invokeMethod('setImagePlaceHolder', path);
    return result;
  }

  // calculate size
  double _calculatePixelRatio(BuildContext context){
    MediaQueryData queryData = MediaQuery.of(context);
    return Platform.isAndroid ? queryData.devicePixelRatio : 1.0;
  }
}
