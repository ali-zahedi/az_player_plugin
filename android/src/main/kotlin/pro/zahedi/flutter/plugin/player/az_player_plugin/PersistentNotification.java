package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.graphics.Bitmap;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import android.support.v4.media.session.MediaSessionCompat;

import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.ext.mediasession.MediaSessionConnector;
import com.google.android.exoplayer2.ui.PlayerNotificationManager;
import com.google.android.exoplayer2.ui.PlayerNotificationManager.BitmapCallback;
import com.google.android.exoplayer2.ui.PlayerNotificationManager.MediaDescriptionAdapter;
import com.google.android.exoplayer2.ui.PlayerNotificationManager.NotificationListener;

import static pro.zahedi.flutter.plugin.player.az_player_plugin.C.PLAYBACK_CHANNEL_ID;
import static pro.zahedi.flutter.plugin.player.az_player_plugin.C.PLAYBACK_NOTIFICATION_ID;

class PersistentNotification {
    private Service service;
    private PlayerNotificationManager playerNotificationManager;
    private MediaSessionCompat mediaSession;
    private MediaSessionConnector mediaSessionConnector;
    private PlayerService playerService;

    PersistentNotification(Service service, PlayerService playerService) {
        this.playerService = playerService;
        this.service = service;
    }

    static void create(Service service, PlayerService playerService) {
        PersistentNotification n = new PersistentNotification(service, playerService);
        n.createNotification();

    }

    @SuppressLint("WrongConstant")
    void createNotification() {
        playerNotificationManager = PlayerNotificationManager.createWithNotificationChannel(service,
                PLAYBACK_CHANNEL_ID, R.string.playback_channel_name, PLAYBACK_NOTIFICATION_ID,
                new MyMediaDescriptionAdapter());

        playerNotificationManager.setNotificationListener(new MyNotificationListener());
        playerNotificationManager.setPlayer(playerService.getPlayer());
        playerNotificationManager.setVisibility(NotificationCompat.VISIBILITY_PUBLIC);
        playerNotificationManager.setUseNavigationActions(false);
    }

    private class MyMediaDescriptionAdapter implements MediaDescriptionAdapter {

        @Override
        public String getCurrentContentTitle(Player player) {
            File file = playerService.getCurrentFile();
            if (file != null)
                return playerService.getCurrentFile().title;
            else
                return "";
        }

        @Nullable
        @Override
        public PendingIntent createCurrentContentIntent(Player player) {
            return null;
        }

        @Nullable
        @Override
        public String getCurrentContentText(Player player) {
//            return playerService.getCurrentFile().title;
            return "";
        }

        @Nullable
        @Override
        public Bitmap getCurrentLargeIcon(Player player, BitmapCallback callback) {
            return playerService.getCurrentImage();
        }
    }

    class MyNotificationListener implements NotificationListener {

        @Override
        public void onNotificationStarted(int notificationId, Notification notification) {
            service.startForeground(notificationId, notification);
        }

        @Override
        public void onNotificationCancelled(int notificationId) {
            service.stopSelf();
        }
    }
}
