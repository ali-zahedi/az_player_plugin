package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.IBinder;

import org.jetbrains.annotations.Nullable;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener;
import io.flutter.view.FlutterNativeView;

/**
 * AzPlayerPlugin
 */
public class AzPlayerPlugin implements MethodCallHandler, ViewDestroyListener {
    // Static and Volatile attribute.
    private static volatile AzPlayerPlugin instance = null;
    private AudioServiceBinder audioServiceBinder = null;

    private Registrar registrar;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "az_player_plugin");
        channel.setMethodCallHandler(AzPlayerPlugin.getInstance(registrar));
        registrar.platformViewRegistry().registerViewFactory("PlayerView", new FlutterPlayerViewFactory(registrar.messenger()));
    }

    private AzPlayerPlugin(Registrar registrar) {
        this.registrar = registrar;
        PlayerService.getInstance(registrar.context());
        bindService();
    }

    // Static function.
    protected static AzPlayerPlugin getInstance() {
        return AzPlayerPlugin.getInstance(null);
    }

    protected static AzPlayerPlugin getInstance(@Nullable Registrar registrar) {
        // Double check locking principle.
        // If there is no instance available, create new one (i.e. lazy initialization).
        if (instance == null && registrar != null) {

            // To provide thread-safe implementation.
            synchronized (AzPlayerPlugin.class) {

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
            case "duration": {

                result.success(PlayerService.getInstance().getTotalTime());
                break;
            }
            case "currentTime": {
                result.success(PlayerService.getInstance().getCurrentTime());
                break;
            }
            case "secondsLeft": {
                result.success(PlayerService.getInstance().getTotalTime() - PlayerService.getInstance().getCurrentTime());
                break;
            }
            case "currentFile": {
                File current = PlayerService.getInstance().getCurrentFile();
                if (current != null)
                    result.success(current.pk);
                else {
                    result.success(null);
                }
                break;
            }
            case "isPlaying": {
                result.success(PlayerService.getInstance().isPlaying());
                break;
            }
            case "play": {
                PlayerService.getInstance().play();
                result.success(true);
                break;
            }
            case "playWithFile": {
                Map<String, Object> filesJson = (Map<String, Object>) call.arguments;
                PlayerService.getInstance().playWithFile(File.fromJson(filesJson));
                result.success(true);
                break;
            }
            case "pause": {
                PlayerService.getInstance().pause();
                result.success(true);
                break;
            }
            case "stop": {
                PlayerService.getInstance().stop();
                result.success(true);
                break;
            }
            case "addFileToPlayList": {
                Map<String, Object> filesJson = (Map<String, Object>) call.arguments;
                PlayerService.getInstance().addFileToList(File.fromJson(filesJson));
                result.success(true);
                break;
            }
            case "addFilesToPlayList": {
                List<File> files = new ArrayList<>();
                List<Map<String, Object>> filesJson = (List<Map<String, Object>>) call.arguments;
                for (int i = 0; i < filesJson.size(); i++) {
                    files.add(File.fromJson(filesJson.get(i)));
                }
                PlayerService.getInstance().addFilesToList(files);
                result.success(true);
                break;
            }
            case "emptyPlayList": {
                PlayerService.getInstance().emptyPlayList();
                result.success(true);
                break;
            }
            case "removeFromPlayList": {
                Map<String, Object> filesJson = (Map<String, Object>) call.arguments;
                PlayerService.getInstance().removeFromPlayList(File.fromJson(filesJson));
                result.success(true);
                break;
            }
            case "setImagePlaceHolder": {
                String filePath = call.arguments.toString();

                try {
                    String key = registrar.lookupKeyForAsset(filePath);
                    PlayerService.getInstance().setImagePlaceHolderPath(key);
                    result.success(true);
                } catch (Exception e) {
                    result.success(false);
                }

                break;
            }
            case "getPlayList": {

                //TODO : ?
                break;
            }
            case "next": {
                PlayerService.getInstance().playNext();
                result.success(true);
                break;
            }
            case "previous": {
                PlayerService.getInstance().playBackward();
                result.success(true);
                break;
            }
            case "fastForward": {
                PlayerService.getInstance().fastForward();
                result.success(true);
                break;
            }
            case "fastBackward": {
                PlayerService.getInstance().fastBackward();
                result.success(true);
                break;
            }
            case "changeTime": {
                PlayerService.getInstance().changeCurrentTime(Double.parseDouble(call.arguments.toString()));
                result.success(true);
                break;
            }
            case "changeScreenSize": {
                Map<String, Object> sizeJson = (Map<String, Object>) call.arguments;
                double width = Double.parseDouble(sizeJson.get("width").toString());
                double height = Double.parseDouble(sizeJson.get("height").toString());
                PlayerService.getInstance().setPlayerViewSize(width, height);
                result.success(true);
                break;
            }
        }
    }

    @Override
    public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        unBoundService();
        return false;
    }

    protected void bindService() {

        if (this.isAllowToBindAudioService()) {
            Intent intent = new Intent(registrar.context(), AudioService.class);
            registrar.context().bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
        }
    }

    protected void unBoundService() {
        if (!this.isAllowToBindAudioService()) {
            audioServiceBinder.destroyAllPlayers();
            registrar.context().unbindService(serviceConnection);
            audioServiceBinder = null;
        }
    }

    protected boolean isAllowToBindAudioService(){
        return audioServiceBinder == null;
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
