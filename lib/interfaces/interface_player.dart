import 'package:az_player_plugin/az_player_plugin.dart';
import 'package:flutter/material.dart';

abstract class InterfacePlayer{
	
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
	
	Widget getPlayerView({num width=300, num height=300});
	
	Future<bool> play();
	
	Future<bool> playWithFile(InterfaceFile file);
	
	Future<bool> pause();
	
	Future<bool> stop();
	
	Future<bool> addFileToPlayList(InterfaceFile file);
	
	Future<bool> addFilesToPlayList(List<InterfaceFile> files);
	
	// دستور برای خالی کردن پلی لیست
	Future<bool> emptyPlayList();
	
	Future<bool> removeFromPlayList(InterfaceFile file);
	
	Future<List<InterfaceFile>> getPlayList();
	
	Future<bool> next();
	
	Future<bool> previous();
	
	Future<bool> changeTime(num toSecond);
	
	// می توانید با استفاده از این فانکشن از تغییرات آگاه شوید.
//	void setCallBack(PlayerCallBack callBack);
	
}