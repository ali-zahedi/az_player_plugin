# az_player_plugin_example

You can follow and see git hub repository.

Please rate/start and contribute if find it helpful. 

### Usage

import package: 

`import 'package:az_player_plugin/az_player_plugin.dart' as AZPlayerPlugin;`

#### Define File

`var file = AZPlayerPlugin.File(
      0,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title",
      0,
      AZPlayerPlugin.FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );`
    
### Add file to play list


1. Add one file:

> `AZPlayerPlugin.AzPlayerPlugin().addFileToPlayList(file);`

2. Add multi file:

> `AZPlayerPlugin.AzPlayerPlugin().addFilesToPlayList([file]);`

Note: file/files append together in playlist.

### Core functionality

1. play :

> `AZPlayerPlugin.AzPlayerPlugin().play();`

or

> `AZPlayerPlugin.AzPlayerPlugin().AZPlayerPlugin.AzPlayerPlugin().playWithFile(file);`

2. pause:

> `AZPlayerPlugin.AzPlayerPlugin().pause();`

3. get total time of file is playing:

> `AZPlayerPlugin.AzPlayerPlugin().duration;`

4. get time left:

> `AZPlayerPlugin.AzPlayerPlugin().secondsLeft;`

5. get current time:

> `AZPlayerPlugin.AzPlayerPlugin().currentTime;`

6. file is playing?

> `AZPlayerPlugin.AzPlayerPlugin().isPlaying;`

7. get player view to attach your custom view:

> `AZPlayerPlugin.AzPlayerPlugin().getPlayerView(width: 300, height: 100);`

or 

> `AZPlayerPlugin.AzPlayerPlugin().getPlayerView();`

8. stop:

> `AZPlayerPlugin.AzPlayerPlugin().stop();`

9. fastForward, current time +15 seconds:

> `AZPlayerPlugin.AzPlayerPlugin().fastForward();`

10. fastBackward, current time - 5 seconds:

> `AZPlayerPlugin.AzPlayerPlugin().fastForward();`

11. emptyPlayList, command for delete all files in playlist:

> `AZPlayerPlugin.AzPlayerPlugin().emptyPlayList();`

12. removeFromPlayList, remove special file from playlist:

> `AZPlayerPlugin.AzPlayerPlugin().removeFromPlayList(file);`

13. next track:

> `AZPlayerPlugin.AzPlayerPlugin().next();`

14. previous track:

> `AZPlayerPlugin.AzPlayerPlugin().previous();`

15. change time to special second:

> `AZPlayerPlugin.AzPlayerPlugin().changeTime(17);`


You must read every one seconds to update your player, like (slider, timer and etc to update time).
