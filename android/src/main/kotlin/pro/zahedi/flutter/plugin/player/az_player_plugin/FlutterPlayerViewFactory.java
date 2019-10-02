package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.Context;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FlutterPlayerViewFactory extends PlatformViewFactory {


    public FlutterPlayerViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {
        HashMap<String, Object> params = (HashMap<String, Object>) o;
        PlayerService.getInstance().setPlayerViewSize(Double.parseDouble(params.get("width").toString()), Double.parseDouble(params.get("height").toString()));
        return PlayerView.getInstance();
    }
}
