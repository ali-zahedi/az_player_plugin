package pro.zahedi.flutter.plugin.player.az_player_plugin;
import android.content.Context;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FlutterPlayerViewFactory extends PlatformViewFactory {
    public FlutterPlayerViewFactory(MessageCodec<Object> createArgsCodec) {
        super(createArgsCodec);
        // I think you can save args like frame( width and height) and use it in create method
    }

    @Override
    public PlatformView create(Context context, int i, Object o) {
        // TODO: in this line you must call player service and update frame
        // like:
        // PlayerService.getInstance().getPlayerView(width: this.width, height: this.height);
        // after that return player view
        return new PlayerView();
    }
}
