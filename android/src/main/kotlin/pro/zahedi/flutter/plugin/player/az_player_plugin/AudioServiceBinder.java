package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.Context;
import android.net.Uri;
import android.os.Binder;
import android.text.TextUtils;
import io.flutter.plugin.common.MethodChannel.Result;
import android.app.Service;
import android.util.Log;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.IBinder;

import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.util.Util;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;

public class AudioServiceBinder extends Binder {

    private Service service;

    AudioServiceBinder(Service service) {
        this.service = service;
    }


    public void create(Context context) {
//        Log.i(TAG, "starting player in bakground");
//        TextureRegistry.SurfaceTextureEntry handle = registrar.textures().createSurfaceTexture();
//
//        EventChannel eventChannel = new EventChannel(registrar.messenger(), "media_player_event_channel" + handle.id());
//
        PlayerService player = PlayerService.getInstance(context);

//        player = new VideoPlayer(registrar.context(), eventChannel, handle, result);
//        if ((boolean) call.argument("showNotification")) {
            PersistentNotification.create(service, player);
//        }

    }

    public void destroyAllPlayers() {
//        for (Long key : videoPlayers.keySet()) {
//            videoPlayers.get(key).dispose();
//           //  System.out.println("Key = " + key);
//        }
        // TODO: handle for loop
//        PlayerService.getInstance().dispose();
    }

    public void removePlayer(long textureId) {
//        videoPlayers.remove(textureId);
    }

}
