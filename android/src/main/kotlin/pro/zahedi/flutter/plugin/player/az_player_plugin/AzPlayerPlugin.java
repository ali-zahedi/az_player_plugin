package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;


import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener;
import io.flutter.view.FlutterNativeView;

/** AzPlayerPlugin */
public class AzPlayerPlugin implements MethodCallHandler, ViewDestroyListener {
    // Static and Volatile attribute.
    private static volatile AzPlayerPlugin instance = null;
    private AudioServiceBinder audioServiceBinder = null;

    private Registrar registrar;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "az_player_plugin");
        channel.setMethodCallHandler(AzPlayerPlugin.getInstance(registrar));
    }

    private AzPlayerPlugin(Registrar registrar){
        this.registrar = registrar;
        this.bindService();
    }

    // Static function.
    private static AzPlayerPlugin getInstance(Registrar registrar) {
        // Double check locking principle.
        // If there is no instance available, create new one (i.e. lazy initialization).
        if (instance == null) {

            // To provide thread-safe implementation.
            synchronized(AzPlayerPlugin.class) {

                // Check again as multiple threads can reach above step.
                if (instance == null) {
                    instance = new AzPlayerPlugin(registrar);
                }
            }
        }
        return instance;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "duration":{

                result.success(PlayerService.getInstance().getTotalTime());
                break;
            }
            case "currentTime":{
                result.success(PlayerService.getInstance().getCurrentTime());
                break;
            }
            case "secondsLeft":{
                result.success(PlayerService.getInstance().getTotalTime() - PlayerService.getInstance().getCurrentTime());
                break;
            }
            case "currentFile":{

                break;
            }
            case "isPlaying":{
                result.success(PlayerService.getInstance().isPlaying());
                break;
            }
            case "play":{
                PlayerService.getInstance().play();
                result.success(true);
                break;
            }
            case "playWithFile":{

                break;
            }
            case "pause":{
                PlayerService.getInstance().pause();
                result.success(true);
                break;
            }
            case "stop":{
                PlayerService.getInstance().stop();
                result.success(true);
                break;
            }
            case "addFileToPlayList":{

                break;
            }
            case "addFilesToPlayList":{
                List<File> files = new ArrayList<>();
                files.add(new File(0, "title 0", 0, "http://dl13.f2m.co/user/shahab/serial/Bard.Of.Blood/S01/Bard.Of.Blood.S01.360p.Trailer.Film2Movie_WS.mp4", "https://cdn.aparnik.com/static/website/img/logo-persian.png", FileStatus.ready));
                files.add(new File(1, "title 0", 0, "http://dl.nex1music.ir/1398/07/06/Saeed%20Foroughi%20-%20Hese%20Romantic%20[128].mp3?time=1569664803&filename=/1398/07/06/Saeed%20Foroughi%20-%20Hese%20Romantic%20[128].mp3", "https://cdn.aparnik.com/static/website/img/logo-persian.png", FileStatus.ready));
                PlayerService.getInstance().addFilesToList(files);
                break;
            }
            case "emptyPlayList":{

                break;
            }
            case "removeFromPlayList":{

                break;
            }
            case "getPlayList":{

                break;
            }
            case "next":{
                PlayerService.getInstance().playNext();
                result.success(true);
                break;
            }
            case "previous":{
                PlayerService.getInstance().playBackward();
                result.success(true);
                break;
            }
            case "changeTime":{

                break;
            }
        }
    }

    @Override
    public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        unBoundService();
        return false;
    }

    private void bindService() {

        if (audioServiceBinder == null) {
            Intent intent = new Intent(registrar.context(), AudioService.class);
            registrar.context().bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
        }
    }

    private void unBoundService() {
        if (audioServiceBinder != null){
            audioServiceBinder.destroyAllPlayers();
            registrar.context().unbindService(serviceConnection);

        }
    }

    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
//            Log.i("ServiceConnnection", "Service connection audio service binder");
            audioServiceBinder = (AudioServiceBinder) iBinder;
            audioServiceBinder.create(registrar.context());
//            Log.i("ServiceConnnection", "Service connection audio service binder complete");
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
//            Log.i("ServiceConnnection", "Service disconnected");

        }
    };
}
