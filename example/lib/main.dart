import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:az_player_plugin/az_player_plugin.dart' as AZPlayerPlugin;

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
    List<AZPlayerPlugin.File> files = [];
    var file = AZPlayerPlugin.File(
      0,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title 0",
      0,
      AZPlayerPlugin.FileStatus.ready,
      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
    );

    files.add(file);

    file = AZPlayerPlugin.File(
      1,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title 1",
      10,
      AZPlayerPlugin.FileStatus.ready,
      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
    );

    files.add(file);

    file = AZPlayerPlugin.File(
      3,
      "http://dls.tabanmusic.com/music/1398/06/26/Shahab-Mozaffari-Setayesh.mp3",
      "title 2",
      20,
      AZPlayerPlugin.FileStatus.ready,
      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
    );

    files.add(file);

    file = AZPlayerPlugin.File(
      4,
      "http://dls.tabanmusic.com/music/1398/07/01/Mehrad-Jam-Khialet-Rahat.mp3",
      "title 3",
      100,
      AZPlayerPlugin.FileStatus.ready,
      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
    );
    
    AZPlayerPlugin.AzPlayerPlugin().setImagePlaceHolder('assets/logo.png');

    AZPlayerPlugin.AzPlayerPlugin().addFilesToPlayList(files);
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("play: ${await AZPlayerPlugin.AzPlayerPlugin().play()}");
      print("play: ${await AZPlayerPlugin.AzPlayerPlugin().playWithFile(file)}");
    });

    seconds += delay;

    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("duration: ${await AZPlayerPlugin.AzPlayerPlugin().duration}");
      print("change time: ${await AZPlayerPlugin.AzPlayerPlugin().changeTime(10)}");
      print("currentTime: ${await AZPlayerPlugin.AzPlayerPlugin().currentTime}");
      AZPlayerPlugin.InterfaceFile file = await AZPlayerPlugin.AzPlayerPlugin().currentFile;
      print("currentFile: ${file.title}");
    });

    seconds += delay;

    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("pause: ${await AZPlayerPlugin.AzPlayerPlugin().pause()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().play()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("next: ${await AZPlayerPlugin.AzPlayerPlugin().next()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("next: ${await AZPlayerPlugin.AzPlayerPlugin().next()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("previous: ${await AZPlayerPlugin.AzPlayerPlugin().previous()}");
    });

    seconds += delay;
    Future.delayed(Duration(seconds: seconds)).then((elem) async {
      print("stop: ${await AZPlayerPlugin.AzPlayerPlugin().stop()}");
    });
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
                child: AZPlayerPlugin.AzPlayerPlugin().getPlayerView(width: 300, height: 100),
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
    AZPlayerPlugin.AzPlayerPlugin().next();
  }
  
  
  _playButtonAction() {
    if(this._isPlaying){
      AZPlayerPlugin.AzPlayerPlugin().pause();
    }else{
      AZPlayerPlugin.AzPlayerPlugin().play();
    }
    setState(() {
      this._isPlaying = !this._isPlaying;
    });
  }
  
  _onBackTrackButtonAction() {
    AZPlayerPlugin.AzPlayerPlugin().previous();
  }
  
  void _onSliderValueChange(double value) {
    //TODO: handle slider onchange
    setState(() {
      this._fileCurrentPlayTimeMs = value;
    });
  }
}
