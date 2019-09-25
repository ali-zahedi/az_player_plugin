import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:az_player_plugin/az_player_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
//      platformVersion = await AzPlayerPlugin().platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    var seconds = 2;
    var delay = 10;
    List<File> files = [];
    var file = File(
      0,
      FileStatus.ready,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
      0,
      "title 0",
    );
    
    files.add(file);
    
    file = File(
      1,
      FileStatus.ready,
      "http://dls.tabanmusic.com/music/1398/06/26/Shahab-Mozaffari-Setayesh.mp3",
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
      0,
      "title 0",
    );

    files.add(file);

    file = File(
      3,
      FileStatus.ready,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
      0,
      "title 0",
    );

    files.add(file);

    file = File(
      4,
      FileStatus.ready,
      "http://dls.tabanmusic.com/music/1398/07/01/Mehrad-Jam-Khialet-Rahat.mp3",
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
      0,
      "title 0",
    );
  
    files.add(file);
    
    AzPlayerPlugin().addFileToPlayList(file);
    AzPlayerPlugin().addFilesToPlayList(files);
    
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("play: ${await AzPlayerPlugin().play()}");
    });

    seconds += delay;

    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("duration: ${await AzPlayerPlugin().duration}");
      print("change time: ${await AzPlayerPlugin().changeTime(10)}");
      print("currentTime: ${await AzPlayerPlugin().currentTime}");
    });

    seconds += delay;

    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("pause: ${await AzPlayerPlugin().pause()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AzPlayerPlugin().play()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("next: ${await AzPlayerPlugin().next()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("next: ${await AzPlayerPlugin().next()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("previous: ${await AzPlayerPlugin().previous()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("stop: ${await AzPlayerPlugin().stop()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: AzPlayerPlugin()
              .getPlayerView(), //Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
