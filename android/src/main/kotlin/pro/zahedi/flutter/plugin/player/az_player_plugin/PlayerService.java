package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.Context;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.view.Surface;

import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.ExoPlaybackException;
import com.google.android.exoplayer2.ExoPlayerFactory;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.audio.AudioAttributes;
import com.google.android.exoplayer2.extractor.DefaultExtractorsFactory;
import com.google.android.exoplayer2.source.ConcatenatingMediaSource;
import com.google.android.exoplayer2.source.ExtractorMediaSource;
import com.google.android.exoplayer2.source.MediaSource;
import com.google.android.exoplayer2.source.smoothstreaming.DefaultSsChunkSource;
import com.google.android.exoplayer2.source.smoothstreaming.SsMediaSource;
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector;
import com.google.android.exoplayer2.trackselection.TrackSelector;
import com.google.android.exoplayer2.upstream.DataSource;
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory;
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource;
import com.google.android.exoplayer2.upstream.DefaultHttpDataSourceFactory;
import com.google.android.exoplayer2.util.Util;

import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.TextureRegistry;

import static com.google.android.exoplayer2.Player.REPEAT_MODE_ALL;

public class PlayerService {

    // Static and Volatile attribute.
    private static volatile PlayerService instance = null;

    // Private constructor.
    private PlayerService(Context context) {
        this.context = context;
        TrackSelector trackSelector = new DefaultTrackSelector();

        this.player = ExoPlayerFactory.newSimpleInstance(context, trackSelector);
        this.setupPlayer();
    }

    // Static function.
    public static PlayerService getInstance(@Nullable Context context) {
        // Double check locking principle.
        // If there is no instance available, create new one (i.e. lazy initialization).
        if (instance == null && context != null) {

            // To provide thread-safe implementation.
            synchronized(PlayerService.class) {

                // Check again as multiple threads can reach above step.
                if (instance == null) {
                    instance = new PlayerService(context);
                }
            }
        }
        return instance;
    }

    public static PlayerService getInstance() {
        return PlayerService.getInstance(null);
    }

    void dispose() {
        this.stop();
//        Log.i(TAG, "dispose called");
//        textureEntry.release();
//        Log.i(TAG, "textureenry released");
//        eventChannel.setStreamHandler(null);
//        Log.i(TAG, "event channel stopped");

//        if (surface != null) {
//            surface.release();
//        }
        if (this.player != null) {
            this.player.release();
        }
    }

    // Variable
    private Context context;
    private List<File> files = new ArrayList<>();
    private SimpleExoPlayer player;
    private DataSource.Factory dataSourceFactory;
    private MediaSource videoSource;
    // Method
    // Total Time
    protected double getTotalTime(){
        return this.player.getDuration();
    }

    // is Playing
    protected boolean isPlaying(){
        return player.getPlaybackState() == Player.STATE_READY && player.getPlayWhenReady();
    }

    // Current Time
    protected double getCurrentTime(){
        return player.getCurrentPosition();
    }

    protected File getCurrentFile(){
        return new File(0, "title 0", 0, "http://dl13.f2m.co/user/shahab/serial/Bard.Of.Blood/S01/Bard.Of.Blood.S01.360p.Trailer.Film2Movie_WS.mp4", "https://cdn.aparnik.com/static/website/img/logo-persian.png", FileStatus.ready);
        // TODO: fix
//        return null;
    }

    protected void addFileToList(File file){
        this.files.add(file);
        this.setPlaylist();
    }


    protected void addFilesToList(List<File> files){

        this.files.addAll(files);
        this.setPlaylist();
    }

    protected void changeCurrentTime(double seconds){
        long time = Math.round(seconds * 1000);
        this.player.seekTo(time);
    }

    protected void pause(){

        this.player.setPlayWhenReady(false);
    }

    protected void playBackward(){

        // TODO: send play backward to player
    }

    protected void playNext(){

        // TODO: send play next to player
    }

    protected void playWithFile(File file){

        // TODO: find file to play list and play it.
    }

    protected void removeFromPlayList(File file){

        // TODO: find file and remove from playlist
    }

    protected void fastForward(){

        this.changeCurrentTime(this.getCurrentTime() + 15);
    }

    protected void fastBackward(){

        this.changeCurrentTime(this.getCurrentTime() - 5);
    }

    protected void play(){

        this.player.setPlayWhenReady(true);
    }

    protected void stop(){

        this.player.stop();
    }


    private void setupPlayer() {

//        surface = new Surface(textureEntry.surfaceTexture());
//        this.player.setVideoSurface(surface);

        this.player.addListener(new Player.DefaultEventListener() {

            @Override
            public void onPositionDiscontinuity(@Player.DiscontinuityReason int reason) {
//                Log.i(TAG, "position changed called" + reason);

            }

            @Override
            public void onPlayerStateChanged(final boolean playWhenReady, final int playbackState) {
                super.onPlayerStateChanged(playWhenReady, playbackState);

                if (playbackState == Player.STATE_BUFFERING) {
//                    event.put("event", "bufferingUpdate");

                } else if (playWhenReady && playbackState == Player.STATE_READY) {
//                    event.put("event", "play");
                } else if (!playWhenReady && playbackState == Player.STATE_READY) {
//                    event.put("event", "paused");
                }
            }

            @Override
            public void onPlayerError(final ExoPlaybackException error) {
                super.onPlayerError(error);
//                   eventSink.error("VideoError", "Video player had error " + error, null);
                }
        });


    }

    public SimpleExoPlayer getPlayer() {
        return this.player;
    }

    private void setPlaylist() {

        ConcatenatingMediaSource concatenatingMediaSource = new ConcatenatingMediaSource();
        for (int i = 0; i < this.files.size(); i++) {
            Uri uri = Uri.parse(this.files.get(i).fileURL);

            DataSource.Factory dataSourceFactory;
            if (uri.getScheme().equals("asset") || uri.getScheme().equals("file")) {
                dataSourceFactory = new DefaultDataSourceFactory(context, "ExoPlayer");
            } else {
                dataSourceFactory = new DefaultHttpDataSourceFactory("ExoPlayer", null,
                        DefaultHttpDataSource.DEFAULT_CONNECT_TIMEOUT_MILLIS,
                        DefaultHttpDataSource.DEFAULT_READ_TIMEOUT_MILLIS, true);
            }

            MediaSource mediaSource = buildMediaSource(uri, dataSourceFactory, context);
            concatenatingMediaSource.addMediaSource(mediaSource);
        }
        this.player.prepare(concatenatingMediaSource);
    }

    private MediaSource buildMediaSource(Uri uri, DataSource.Factory mediaDataSourceFactory, Context context) {
        int type = Util.inferContentType(uri.getLastPathSegment());
        switch (type) {
            case C.TYPE_SS:
                return new SsMediaSource.Factory(new DefaultSsChunkSource.Factory(mediaDataSourceFactory),
                        new DefaultDataSourceFactory(context, null, mediaDataSourceFactory)).createMediaSource(uri);
            case C.TYPE_OTHER:
                return new ExtractorMediaSource.Factory(mediaDataSourceFactory)
                        .setExtractorsFactory(new DefaultExtractorsFactory()).createMediaSource(uri);
            default: {
                throw new IllegalStateException("Unsupported type: " + type);
            }
        }
    }
}
