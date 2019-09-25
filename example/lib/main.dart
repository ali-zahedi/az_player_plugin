import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:az_player_plugin/az_player_plugin.dart';

void main(){
  print("hello");
  runApp(PlayerScreen());
}


class PlayerScreen extends StatefulWidget {
  final String imagePath = 'images/placeholder1-2.jpg';
  
  const PlayerScreen();
  
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

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
  }
  
  @override
  Widget build(BuildContext context) {
    return PlayerScreen();
  }
}


//AzPlayerPlugin().getPlayerView(), //Text('Running on: $_platformVersion\n'),
class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = false;
  Color _iconColor = Colors.deepOrange;
  double _iconSize = 40;
  double _fileCurrentPlayTimeMs = 3;
  
  @override
  void initState() {
    super.initState();
    var seconds = 2;
    var delay = 10;
    List<File> files = [];
    var file = File(
      0,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title 0",
      0,
      FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );

    files.add(file);

    file = File(
      1,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title 1",
      10,
      FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );

    files.add(file);

    file = File(
      3,
      "http://dls.tabanmusic.com/music/1398/06/26/Shahab-Mozaffari-Setayesh.mp3",
      "title 2",
      20,
      FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );

    files.add(file);

    file = File(
      4,
      "http://dls.tabanmusic.com/music/1398/07/01/Mehrad-Jam-Khialet-Rahat.mp3",
      "title 3",
      100,
      FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );

    files.add(file);
    
    AzPlayerPlugin().addFilesToPlayList(files);

//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("play: ${await AzPlayerPlugin().play()}");
//    });
//
//    seconds += delay;
//
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("duration: ${await AzPlayerPlugin().duration}");
//      print("change time: ${await AzPlayerPlugin().changeTime(10)}");
//      print("currentTime: ${await AzPlayerPlugin().currentTime}");
//    });
//
//    seconds += delay;
//
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("pause: ${await AzPlayerPlugin().pause()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AzPlayerPlugin().play()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("next: ${await AzPlayerPlugin().next()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("next: ${await AzPlayerPlugin().next()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("previous: ${await AzPlayerPlugin().previous()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("stop: ${await AzPlayerPlugin().stop()}");
//    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: AzPlayerPlugin().getPlayerView(width: 300, height: 100),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: this._getButtons(),
                    ),
                    Slider(
                      min: 0,
                      max: 100,
                      value: _fileCurrentPlayTimeMs,
                      onChanged: (value) {
                        this._onSliderValueChange(value);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _getButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.fast_rewind,
            color:_iconColor,
            size: _iconSize,
          ),
          onPressed: () => this._onBackTrackButtonAction(),
        ),
        IconButton(
          icon: (this._isPlaying)
                  ? Icon(
            Icons.pause_circle_outline,
            color: _iconColor,
            size: _iconSize,
          )
                  : Icon(
            Icons.play_circle_outline,
            color: _iconColor,
            size: _iconSize,
          ),
          onPressed: () => this._playButtonAction(),
        ),
        IconButton(
          icon: Icon(
            Icons.fast_forward,
            color:_iconColor,
            size: _iconSize,
          ),
          onPressed: () => this._onNextTrackButtonAction(),
        ),
      ],
    );
  }
  
  _onNextTrackButtonAction() {
    AzPlayerPlugin().next();
  }
  
  
  _playButtonAction() {
    if(this._isPlaying){
      AzPlayerPlugin().pause();
    }else{
      AzPlayerPlugin().play();
    }
    setState(() {
      this._isPlaying = !this._isPlaying;
    });
  }
  
  _onBackTrackButtonAction() {
    AzPlayerPlugin().previous();
  }
  
  void _onSliderValueChange(double value) {
    //TODO: handle slider onchange
    setState(() {
      this._fileCurrentPlayTimeMs = value;
    });
  }
}
