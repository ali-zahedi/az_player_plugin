import 'dart:async';
import 'package:flutter/material.dart';
import 'package:az_player_plugin_example/player_screen_example.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LaunchScreen(),
      ),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((elem){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayerScreenExample()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.purple,);
  }
}


//class PlayerScreen extends StatefulWidget {
//  final String imagePath = 'images/placeholder1-2.jpg';
//
//  const PlayerScreen();
//
//  @override
//  _PlayerScreenState createState() => _PlayerScreenState();
//}
//
////AzPlayerPlugin().getPlayerView(), //Text('Running on: $_platformVersion\n'),
//class _PlayerScreenState extends State<PlayerScreen> {
//  bool _isPlaying = false;
//  Color _iconColor = Colors.deepOrange;
//  double _iconSize = 40;
//  double _fileCurrentPlayTimeMs = 3;
//  num _playerViewWidth = 160;
//  num _playerViewHeight = 90;
//
//  @override
//  void initState() {
//    super.initState();
//    Utilities.withCallback((){
//      this._runSample();
//    });
//
//    Timer timer;
//
//    timer = Timer.periodic(Duration(seconds: 3), (_)
//    {
//      num increase = 50;
//      this._playerViewWidth = this._playerViewWidth + ((increase / 9) * 16);
//      this._playerViewHeight = this._playerViewHeight + increase;
//      print(this._playerViewWidth);
//      print(this._playerViewHeight);
//      setState(() {
//
//      });
//    });
//  }
//
//  Future<void> _runSample() async{
//    print(Utilities().securePath);
//    var seconds = 2;
//    var delay = 10;
//    List<AZPlayerPlugin.File> files = [];
//    var musicVideo = "http://srv1.mihan.xyz/s7/archive/turkish/v/Vefa%20Serifova/video/480/Vefa%20Serifova%20-%20Goresen%20O%20Harda%20[MihanMusic]%20480.mp4";
//    var file = AZPlayerPlugin.File(
//      0,
//      musicVideo,
//      "title 0",
//      0,
//      AZPlayerPlugin.FileStatus.ready,
//      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
//    );
//
//    files.add(file);
//
//    file = AZPlayerPlugin.File(
//      1,
//      musicVideo,
//      "title 1",
//      10,
//      AZPlayerPlugin.FileStatus.ready,
//      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
//    );
//
//    files.add(file);
//
//    file = AZPlayerPlugin.File(
//      3,
//      musicVideo,
//      "title 2",
//      20,
//      AZPlayerPlugin.FileStatus.ready,
//      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
//    );
//
//    files.add(file);
//
//    file = AZPlayerPlugin.File(
//      4,
//      musicVideo,
//      "title 2",
//      100,
//      AZPlayerPlugin.FileStatus.ready,
//      "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
//    );
//
//    AZPlayerPlugin.AzPlayerPlugin().setImagePlaceHolder('assets/logo.png');
//
//    AZPlayerPlugin.AzPlayerPlugin().setRepeatMode(AZPlayerPlugin.PlayMode.REPEAT_ONE);
//    AZPlayerPlugin.AzPlayerPlugin().addFilesToPlayList(files);
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
////      print("play: ${await AZPlayerPlugin.AzPlayerPlugin().play()}");
////      var localAddress = Utilities().joinPath(Utilities().securePath, "900.mp3");
////      print(localAddress);
////      file = AZPlayerPlugin.File(
////        4,
////        localAddress,
////        "title 3",
////        100,
////        AZPlayerPlugin.FileStatus.ready,
////        "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
////      );
//      print("play: ${await AZPlayerPlugin.AzPlayerPlugin().playWithFile(file)}");
//    });
//
//    seconds += delay;
//
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("duration: ${await AZPlayerPlugin.AzPlayerPlugin().duration}");
//      print("change time: ${await AZPlayerPlugin.AzPlayerPlugin().changeTime(10)}");
//      print("currentTime: ${await AZPlayerPlugin.AzPlayerPlugin().currentTime}");
//      AZPlayerPlugin.InterfaceFile file = await AZPlayerPlugin.AzPlayerPlugin().currentFile;
//      print("currentFile: ${file.title}");
//    });
//
//    seconds += delay;
//
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("pause: ${await AZPlayerPlugin.AzPlayerPlugin().pause()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().play()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("next: ${await AZPlayerPlugin.AzPlayerPlugin().next()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("is playing: ${await AZPlayerPlugin.AzPlayerPlugin().isPlaying}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("next: ${await AZPlayerPlugin.AzPlayerPlugin().next()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("previous: ${await AZPlayerPlugin.AzPlayerPlugin().previous()}");
//    });
//
//    seconds += delay;
//    Future.delayed(Duration(seconds: seconds)).then((elem) async {
//      print("stop: ${await AZPlayerPlugin.AzPlayerPlugin().stop()}");
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        body: SafeArea(
//          child: Column(
//            children: <Widget>[
//              Expanded(
//                flex: 1,
//                child: AZPlayerPlugin.AzPlayerPlugin().getPlayerView(context: this.context, width: this._playerViewWidth, height: this._playerViewHeight),
//              ),
//              Expanded(
//                flex: 2,
//                child: Column(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.all(18.0),
//                      child: this._getButtons(),
//                    ),
//                    Slider(
//                      min: 0,
//                      max: 100,
//                      value: _fileCurrentPlayTimeMs,
//                      onChanged: (value) {
//                        this._onSliderValueChange(value);
//                      },
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _getButtons() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        IconButton(
//          icon: Icon(
//            Icons.fast_rewind,
//            color:_iconColor,
//            size: _iconSize,
//          ),
//          onPressed: () => this._onBackTrackButtonAction(),
//        ),
//        IconButton(
//          icon: (this._isPlaying)
//                  ? Icon(
//            Icons.pause_circle_outline,
//            color: _iconColor,
//            size: _iconSize,
//          )
//                  : Icon(
//            Icons.play_circle_outline,
//            color: _iconColor,
//            size: _iconSize,
//          ),
//          onPressed: () => this._playButtonAction(),
//        ),
//        IconButton(
//          icon: Icon(
//            Icons.fast_forward,
//            color:_iconColor,
//            size: _iconSize,
//          ),
//          onPressed: () => this._onNextTrackButtonAction(),
//        ),
//      ],
//    );
//  }
//
//  _onNextTrackButtonAction() {
//    AZPlayerPlugin.AzPlayerPlugin().next();
//  }
//
//
//  _playButtonAction() {
//    if(this._isPlaying){
//      AZPlayerPlugin.AzPlayerPlugin().pause();
//    }else{
//      AZPlayerPlugin.AzPlayerPlugin().play();
//    }
//    setState(() {
//      this._isPlaying = !this._isPlaying;
//    });
//  }
//
//  _onBackTrackButtonAction() {
//    AZPlayerPlugin.AzPlayerPlugin().previous();
//  }
//
//  void _onSliderValueChange(double value) {
//    //TODO: handle slider onchange
//    setState(() {
//      this._fileCurrentPlayTimeMs = value;
//    });
//  }
//}
