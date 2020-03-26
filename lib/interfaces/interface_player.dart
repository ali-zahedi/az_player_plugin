import 'package:az_player_plugin/az_player_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ListenerPlayerInfoFunction = Function(
  InterfaceFile currentFile,
  bool isPlaying,
  num duration,
  num secondsLeft,
  num currentTime,
);

abstract class InterfacePlayer {
  // کل زمان
  Future<num> get duration;

  // زمان گذشته
  Future<num> get secondsLeft;

  // زمان جاری
  Future<num> get currentTime;

  // فایل در حال پخش
  Future<InterfaceFile> get currentFile;

  // در حال پخش بودن
  Future<bool> get isPlaying;

  // 16x9
  Widget getPlayerView(
      {@required BuildContext context,
      num width = 0,
      num height = 0,
      bool isProtectAspectRation = true});

  Future<bool> play();

  Future<bool> playWithFile(InterfaceFile file);

  Future<bool> pause();

  Future<bool> stop();

  Future<bool> setRepeatMode(PlayMode mode);

  Future<bool> fastForward();

  Future<bool> fastBackward();

  Future<bool> addFileToPlayList(InterfaceFile file);

  Future<bool> addFilesToPlayList(List<InterfaceFile> files);

  // دستور برای خالی کردن پلی لیست
  Future<bool> emptyPlayList();

  Future<bool> removeFromPlayList(InterfaceFile file);

  Future<List<InterfaceFile>> getPlayList();

  Future<bool> next();

  Future<bool> previous();

  Future<bool> changeTime(num toSecond);

  // باید از استس خوانده شود
  Future<bool> setImagePlaceHolder(String path);

  // می توانید با استفاده از این فانکشن از تغییرات آگاه شوید.

  ///
  /// Listeners
  /// List of methods to be called when a trigger
  /// comes in.
  ///
  ObserverList<Function(InterfaceFile currentFile)> listenersPlayerScreen;
  ObserverList<ListenerPlayerInfoFunction> listenersPlayerInfo;

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// Player screen
  /// ---------------------------------------------------------
  addListenerPlayerScreen(Function(InterfaceFile currentFile) callback);

  removeListenerPlayerScreen(Function(InterfaceFile currentFile) callback);

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// Player info
  /// ---------------------------------------------------------
  addListenerPlayerInfo(ListenerPlayerInfoFunction callback);

  removeListenerPlayerInfo(ListenerPlayerInfoFunction callback);
}
