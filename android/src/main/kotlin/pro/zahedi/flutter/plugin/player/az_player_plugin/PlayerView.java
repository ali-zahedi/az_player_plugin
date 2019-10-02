package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.view.View;

import io.flutter.plugin.platform.PlatformView;

public class PlayerView implements PlatformView {

    private static PlayerView instance = null;

    private PlayerView() {

    }

    public static PlayerView getInstance() {
        if (instance == null)
            instance = new PlayerView();
        return instance;
    }

    @Override
    public View getView() {

        return PlayerService.getInstance().getPlayerView();
    }

    @Override
    public void dispose() {
        instance = null;
    }
}
