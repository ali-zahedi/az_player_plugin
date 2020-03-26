import 'dart:async';
import 'package:flutter/material.dart';
import 'package:az_player_plugin/az_player_plugin.dart' as AZPlayerPlugin;
import 'package:az_player_plugin_example/utilities.dart';

class PlayerScreenExample extends StatefulWidget {
  @override
  _PlayerScreenExampleState createState() => _PlayerScreenExampleState();
}

class _PlayerScreenExampleState extends State<PlayerScreenExample> {
  List<AZPlayerPlugin.File> _items = [];
  Widget _playerView = Container();

  @override
  void initState() {
    super.initState();
    this._preparePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    AZPlayerPlugin.AzPlayerPlugin().removeListenerPlayerInfo(_onPlayerInfoChangeReceived);
    AZPlayerPlugin.AzPlayerPlugin().removeListenerPlayerScreen(_onPlayerScreenChangeReceived);
  }

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: this._items.length,
            itemBuilder: (BuildContext context, int index) {
              return this._getTile(context, this._items[index]);
            },
          ),
        ),
        bottomNavigationBar: this._getBottomNavigationBar(),
      ),
    );
  }

  void _preparePlayer() {
    this._items.add(
          AZPlayerPlugin.File(
            0,
            "https://www.aparnik.com/media/file/Aerial_Shot_Of_City-2020-03-26_101548.1817680000.892589.mp4",
            "Aerial Shot Of City Short Video",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );
    this._items.add(
          AZPlayerPlugin.File(
            1,
            "https://www.aparnik.com/media/file/Pinball_machine-2020-03-26_102243.5002220000.551222.wav",
            "MP3-1",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );
    this._items.add(
          AZPlayerPlugin.File(
            2,
            "https://www.aparnik.com/media/file/Pexels_Videos_1675442-2020-03-26_101952.9350410000.73909.mp4",
            "Pexels Video Short Video",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );
    this._items.add(
          AZPlayerPlugin.File(
            3,
            "https://www.aparnik.com/media/file/Roulette_play-2020-03-26_102255.7286470000.21835.wav",
            "MP3-2",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );
    this._items.add(
          AZPlayerPlugin.File(
            4,
            "https://www.aparnik.com/media/file/Sports_event-2020-03-26_102308.6989520000.215764.wav",
            "MP3-3",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );
    this._items.add(
          AZPlayerPlugin.File(
            5,
            "https://www.aparnik.com/media/file/Start_of_horse_race-2020-03-26_102324.8762160000.346970.wav",
            "MP3-4",
            0,
            AZPlayerPlugin.FileStatus.ready,
            "https://www.gravatar.com/avatar/07b6e2b2cf9e19feddbb83572ce12d93?s=400&amp;d=identicon&amp;r=PG",
          ),
        );

    // set placeholder
    AZPlayerPlugin.AzPlayerPlugin().setImagePlaceHolder('assets/logo.png');
    // set repeat mode
    AZPlayerPlugin.AzPlayerPlugin()
        .setRepeatMode(AZPlayerPlugin.PlayMode.REPEAT_ALL);
    // add files to play list
    AZPlayerPlugin.AzPlayerPlugin().addFilesToPlayList(this._items);
    // set state
    setState(() {});
    // add callback
    AZPlayerPlugin.AzPlayerPlugin()
        .addListenerPlayerScreen(_onPlayerScreenChangeReceived);
    AZPlayerPlugin.AzPlayerPlugin()
        .addListenerPlayerInfo(_onPlayerInfoChangeReceived);
  }

  Widget _getTile(BuildContext context, AZPlayerPlugin.File item) {
    return Card(
      child: InkResponse(
        enableFeedback: true,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
          height: 40,
          child: Row(
            children: <Widget>[
              Text(
                item.pk.toString(),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                item.title,
              ),
            ],
          ),
        ),
        onTap: () async {
          AZPlayerPlugin.AzPlayerPlugin().playWithFile(item);
        },
      ),
    );
  }

  Widget _getBottomNavigationBar() {
    return Builder(builder: (BuildContext context) {
      return Container(
        color: Colors.black12,
        height: 100,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: this._playerView,
            ),
          ],
        ),
      );
    });
  }

  /// ----------------------------------------------------------
  /// handler for receive trigger PlayerScreen
  /// ----------------------------------------------------------
  void _onPlayerScreenChangeReceived(AZPlayerPlugin.InterfaceFile currentFile) {
    print("chage screen");
    setState(() {
      this._playerView = AZPlayerPlugin.AzPlayerPlugin().getPlayerView(
        context: context,
        width: 100,
        height: 100,
      );
    });
  }

  void _onPlayerInfoChangeReceived(
    AZPlayerPlugin.InterfaceFile currentFile,
    bool isPlaying,
    num duration,
    num secondsLeft,
    num currentTime,
  ) {
    print("pk:" + currentFile.pk.toString());
    print("is playing:" + isPlaying.toString());
    print("duration: " + duration.toString());
    print("secondsLeft: " + secondsLeft.toString());
    print("current time: " + currentTime.toString());
  }
}
