# az_player_plugin

A flutter player plugin for Android and iOS.

This plugin handle background mode playing, for music and video.

Add notification player in notification center and lock screen. Support both android/iOS.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


### Android

#### Step 1. `android/app/AndroidManifest.xml`


1.1. add code below:

> ``<service
     android:name="pro.zahedi.flutter.plugin.player.az_player_plugin.AudioService"
     android:enabled="true"
     android:exported="false">
 </service>``
 
1.2. in `Application` section:

> ``android:usesCleartextTraffic="true"``

1.3. in `Application` section, add the permission for foreground service:

> ``<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />``

#### Step 2. `android/app/build.graddle`

2.1. Add the following dependency

> ``android {
                compileOptions {
                    sourceCompatibility JavaVersion.VERSION_1_8
                    targetCompatibility JavaVersion.VERSION_1_8
                }
        }``

#### Troubleshooting        
##### Android X compatibility. 

If you have an error about android x compatibility, please visit the [Flutter AndroidX compatibility](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility). 

### iOS

#### Step 1. Background mode

Active background mode in show as a picture:

![background mode](ios/Readme/1.png)

#### Step 2. `ios/Runner/Info.plist`

Before the `</dict>
            </plist>` add:
            
2.1. Allow access the internet for play link:

> ``<key>NSAppTransportSecurity</key>
      <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
      </dict>``
      
2.2. Allow show embedded flutter view:

> ``<key>io.flutter.embedded_views_preview</key>
        <true/>``
        
#### Step 3. 

3.1. Choose the application name.

3.2. Minimum `SDK` is `10.0` 

![minimum sdk](ios/Readme/2.png)

#### Troubleshooting

The base flutter project must be `swift` project.

If you want to migrate to `swift` project from `objective-c`. It's easy, you can follow this step in [Stack overflow](https://stackoverflow.com/questions/58231734/flutter-migrate-objective-c-project-to-swift-project-error-when-use-swift-plugi/58231735#58231735)


### Usage

import package: 

``import 'package:az_player_plugin/az_player_plugin.dart' as AZPlayerPlugin;``

#### Define File

``var file = AZPlayerPlugin.File(
      0,
      "http://dl11.f2m.co/trailer/Crawl.2019.360p.Trailer.Film2Movie_WS.mp4",
      "title",
      0,
      AZPlayerPlugin.FileStatus.ready,
      "https://cdn.aparnik.com/static/website/img/logo-persian.png",
    );``
    
### Add file to play list


1. Add one file:

> ``AZPlayerPlugin.AzPlayerPlugin().addFileToPlayList(file);``

2. Add multi file:

> ``AZPlayerPlugin.AzPlayerPlugin().addFilesToPlayList([file]);``

Note: file/files append together in playlist.

### Core functionality

1. play :

> ``AZPlayerPlugin.AzPlayerPlugin().play();``

> ``AZPlayerPlugin.AzPlayerPlugin().AZPlayerPlugin.AzPlayerPlugin().playWithFile(file);``

2. pause:

> ``AZPlayerPlugin.AzPlayerPlugin().pause();``

3. get total time of file is playing:

> ``AZPlayerPlugin.AzPlayerPlugin().duration;``

4. get time left:

> ``AZPlayerPlugin.AzPlayerPlugin().secondsLeft;``

5. get current time:

> ``AZPlayerPlugin.AzPlayerPlugin().currentTime;``

6. file is playing?

> ``AZPlayerPlugin.AzPlayerPlugin().isPlaying;``

7. get player view to attach your custom view:

> ``AZPlayerPlugin.AzPlayerPlugin().getPlayerView(width: 300, height: 100);``

or 

> ``AZPlayerPlugin.AzPlayerPlugin().getPlayerView();``

8. stop:

> ``AZPlayerPlugin.AzPlayerPlugin().stop();``

9. fastForward, current time +15 seconds:

> ``AZPlayerPlugin.AzPlayerPlugin().fastForward();``

10. fastBackward, current time - 5 seconds:

> ``AZPlayerPlugin.AzPlayerPlugin().fastForward();``

11. emptyPlayList, command for delete all files in playlist:

> ``AZPlayerPlugin.AzPlayerPlugin().emptyPlayList();``

12. removeFromPlayList, remove special file from playlist:

> ``AZPlayerPlugin.AzPlayerPlugin().removeFromPlayList(file);``

13. next track:

> ``AZPlayerPlugin.AzPlayerPlugin().next();``

14. previous track:

> ``AZPlayerPlugin.AzPlayerPlugin().previous();``

15. change time to special second:

> ``AZPlayerPlugin.AzPlayerPlugin().changeTime(17);``


You must read every one seconds to update your player, like (slider, timer and etc to update time).

#### TODO:

- [ ] get play list

- [ ] fast forward in iOS

- [ ] fast backward in iOS

- [ ] handle update client. like call back or interval for update timer, slider, play/pause button in framework.