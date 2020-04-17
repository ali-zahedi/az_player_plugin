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

  AzPlayerPlugin._() {
    this._startTimer();
  }

  factory AzPlayerPlugin() {
    return AzPlayerPlugin._instance;
  }

  @override
  Widget playerView;

  LinkedHashSet<File> _files = new LinkedHashSet<File>();
  num _width = 10;
  num _height = 10;
  Timer _timer;
  bool _lastTimeIsPlaying = false;
  InterfaceFile _lastCurrentFile;

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
  void setPlayerView(
      {num width = 0,
      num height = 0,
      bool isProtectAspectRation = true,
      }) async {
    assert(width != null);
    assert(height != null);
    assert(isProtectAspectRation != null);

    if (width == this._width && height == this._height) {
      return;
    }

    await this._dettachPlayerView();

    this._width = width;
    this._height = height;

    this.playerView = Builder(
      builder: (BuildContext context) {
        Widget playerView;

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

        Map<String, String> size = Map();
        size['width'] = (w * _calculatePixelRatio(context)).toString();
        size['height'] = (h * _calculatePixelRatio(context)).toString();

        if (defaultTargetPlatform == TargetPlatform.android) {
          playerView = AndroidView(
            viewType: 'PlayerView',
            creationParams: size,
            creationParamsCodec: StandardMessageCodec(),
          );
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          playerView = UiKitView(
            viewType: 'PlayerView',
            creationParams: size,
            creationParamsCodec: StandardMessageCodec(),
          );
        } else {
          playerView = Container();
        }

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
      },
    );
    this._onReceptionOfTriggerPlayerScreen(this.playerView);
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
    await this._dettachPlayerView();
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
  Future<bool> setRepeatMode(PlayMode mode) async {
    final bool result =
        await _channel.invokeMethod('setRepeatMode', mode.toString());
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
  double _calculatePixelRatio(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Platform.isAndroid ? queryData.devicePixelRatio : 1.0;
  }

  ///
  /// Listeners
  /// List of methods to be called when a trigger
  /// comes in.
  ///
  @override
  ObserverList<Function(Widget playerView)> listenersPlayerScreen =
      new ObserverList<Function(Widget playerView)>();

  @override
  ObserverList<ListenerPlayerInfoFunction> listenersPlayerInfo =
      new ObserverList<ListenerPlayerInfoFunction>();

  @override
  ObserverList<Function()> listenersDettachPlayerView =
  new ObserverList<Function()>();

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// Player screen
  /// ---------------------------------------------------------
  @override
  void addListenerPlayerScreen(Function(Widget playerView) callback) {
    this.listenersPlayerScreen.add(callback);
  }

  @override
  void addListenerDettachPlayerView(Function() callback) {
    this.listenersDettachPlayerView.add(callback);
  }

  @override
  void removeListenerPlayerScreen(Function(Widget playerView) callback) {
    this.listenersPlayerScreen.remove(callback);
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// Player info
  /// ---------------------------------------------------------
  @override
  void addListenerPlayerInfo(ListenerPlayerInfoFunction callback) {
    this.listenersPlayerInfo.add(callback);
  }

  @override
  void removeListenerPlayerInfo(ListenerPlayerInfoFunction callback) {
    this.listenersPlayerInfo.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a trigger
  /// ----------------------------------------------------------
  void _onReceptionOfTriggerPlayerScreen(Widget playerView) {
    this.listenersPlayerScreen.forEach((Function(Widget playerView) callback) {
      callback(playerView);
    });
  }

  @override
  void removeListenerDettachPlayerView(Function() callback) {
    this.listenersDettachPlayerView.remove(callback);
  }

  Future<void> _dettachPlayerView() {
    this.listenersDettachPlayerView.forEach((Function() callback) async {
      await callback();
    });
    return Future.delayed(Duration(milliseconds: 500));
  }

  void _onReceptionOfTriggerPlayerInfo(
    InterfaceFile currentFile,
    bool isPlaying,
    num duration,
    num secondsLeft,
    num currentTime,
  ) {
    this.listenersPlayerInfo.forEach((ListenerPlayerInfoFunction callback) {
      callback(
        currentFile,
        isPlaying,
        duration,
        secondsLeft,
        currentTime,
      );
    });
  }

  void _startTimer() {
    const oneDecimal = const Duration(seconds: 1);
    this._timer = new Timer.periodic(oneDecimal, (Timer timer) async {
      bool isPlaying = await this.isPlaying;
      if (_timer.isActive &&
          (this._lastTimeIsPlaying != isPlaying || isPlaying)) {
        this._lastTimeIsPlaying = isPlaying;
        InterfaceFile currentFile = await this.currentFile;
        num duration = await this.duration;
        num secondsLeft = await this.secondsLeft;
        num currentTime = await this.currentTime;

        this._onReceptionOfTriggerPlayerInfo(
          currentFile,
          isPlaying,
          duration,
          secondsLeft,
          currentTime,
        );

        if (_lastCurrentFile != currentFile) {
          this._lastCurrentFile = currentFile;
          this._onReceptionOfTriggerPlayerScreen(this.playerView);
        }
      }
    });
  }


}
