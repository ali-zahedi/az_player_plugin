package pro.zahedi.flutter.plugin.player.az_player_plugin;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.webkit.URLUtil;
import android.widget.FrameLayout;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.ExoPlaybackException;
import com.google.android.exoplayer2.ExoPlayerFactory;
import com.google.android.exoplayer2.PlaybackParameters;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.Timeline;
import com.google.android.exoplayer2.extractor.DefaultExtractorsFactory;
import com.google.android.exoplayer2.source.ConcatenatingMediaSource;
import com.google.android.exoplayer2.source.ExtractorMediaSource;
import com.google.android.exoplayer2.source.MediaSource;
import com.google.android.exoplayer2.source.TrackGroupArray;
import com.google.android.exoplayer2.source.smoothstreaming.DefaultSsChunkSource;
import com.google.android.exoplayer2.source.smoothstreaming.SsMediaSource;
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector;
import com.google.android.exoplayer2.trackselection.TrackSelectionArray;
import com.google.android.exoplayer2.trackselection.TrackSelector;
import com.google.android.exoplayer2.upstream.DataSource;
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory;
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource;
import com.google.android.exoplayer2.upstream.DefaultHttpDataSourceFactory;
import com.google.android.exoplayer2.util.Util;

import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class PlayerService {

    // Static and Volatile attribute.
    private static volatile PlayerService instance = null;
    private FrameLayout playerView = null;
    private SurfaceView surfaceView;
    private ImageView imageView;
    private BitmapDrawable currentImage;
    private ConcatenatingMediaSource concatenatingMediaSource;

    private double width = 0;
    private double height = 0;

    private int currentPosition = 0;

    private String imagePlaceHolderPath;


    // Private constructor.
    private PlayerService(Context context) {
        this.context = context;
        concatenatingMediaSource = new ConcatenatingMediaSource();
        TrackSelector trackSelector = new DefaultTrackSelector();
        this.player = ExoPlayerFactory.newSimpleInstance(context, trackSelector);
        this.setupPlayer();
    }

    public Bitmap getCurrentImage()
    {
        if (currentImage ==null) return  null;
        return currentImage.getBitmap();
    }

    // Static function.
    public static PlayerService getInstance(@Nullable Context context) {
        // Double check locking principle.
        // If there is no instance available, create new one (i.e. lazy initialization).
        if (instance == null && context != null) {

            // To provide thread-safe implementation.
            synchronized (PlayerService.class) {

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

    public View getPlayerView() {
        if (playerView == null) {
            initialView();
        }
        return playerView;
    }

    public void setImagePlaceHolderPath(String path) {
        imagePlaceHolderPath = path;
    }

    private void initialView() {
        if (playerView == null) {
            playerView = new FrameLayout(context);
            playerView.setBackgroundColor(Color.BLACK);
        }
//        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams((int) width, (int) height);

        File currentFile = getCurrentFile();
        if (this.player.getVideoFormat() == null) {
            if (imageView == null) {
                imageView = new ImageView(context);
                imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
            }
            Drawable d = null;
            try {
                d = Drawable.createFromStream(context.getAssets().open(imagePlaceHolderPath), null);
                currentImage = (BitmapDrawable)d;
            } catch (Exception e) {
            }

            RequestOptions option = new RequestOptions().placeholder(d).error(d);
            String imagePath = currentFile == null ? "" : currentFile.image;
            Glide.with(context).setDefaultRequestOptions(option).load(imagePath).into(imageView);
//            imageView.setLayoutParams(params);
            playerView.removeAllViews();
            playerView.addView(imageView);
        } else {
            if (surfaceView == null) {
                surfaceView = new SurfaceView(context);
                this.player.setVideoSurfaceView(surfaceView);
            }
//            surfaceView.setLayoutParams(params);
            playerView.removeAllViews();
            playerView.addView(surfaceView);
        }
//        FrameLayout.LayoutParams viewParams = new FrameLayout.LayoutParams((int) width, (int) height);
//        playerView.setLayoutParams(params);
        this.applySizeScreen();
        playerView.invalidate();
    }

    private void applySizeScreen(){
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams((int) width, (int) height);
        if(imageView != null)
            imageView.setLayoutParams(params);
        if(surfaceView != null)
            surfaceView.setLayoutParams(params);
        if(playerView != null)
            playerView.setLayoutParams(params);
    }

    public void setPlayerViewSize(double width, double height) {
        this.width = width;
        this.height = height;
        this.applySizeScreen();
    }

    void dispose() {
        this.stop();
        Log.i("Player", "dispose called");
        // TODO: handle
//        if (this.player != null) {
//            this.player.release();
//        }
    }

    // Variable
    private Context context;
    private List<File> files = new ArrayList<>();
    private SimpleExoPlayer player;

    // Method
    // Total Time
    protected double getTotalTime() {
        double duration = this.player.getDuration() / 1000;
        return duration < 0 ? 0 : duration;
    }

    // is Playing
    protected boolean isPlaying() {
        return player.getPlaybackState() == Player.STATE_READY && player.getPlayWhenReady();
    }

    // Current Time
    protected double getCurrentTime() {
        return player.getCurrentPosition() / 1000;
    }

    protected File getCurrentFile() {

        if (files.size() == 0) {
            return null;
        }
        return files.get(this.player.getCurrentWindowIndex());
    }

    protected void addFileToList(File file) {
        this.files.add(file);
        this.setPlaylist(Collections.singletonList(file));
    }


    protected void addFilesToList(List<File> files) {

        this.files.addAll(files);
        this.setPlaylist(files);
    }

    protected void changeCurrentTime(double seconds) {
        long time = Math.round(seconds);
        this.player.seekTo(time * 1000);
    }

    protected void pause() {

        this.player.setPlayWhenReady(false);
    }

    protected void playBackward() {
        preparePlayerService();
        this.player.previous();
        currentPosition = this.player.getCurrentWindowIndex();
    }

    protected void playNext() {
        preparePlayerService();
        this.player.next();
        currentPosition = this.player.getCurrentWindowIndex();
    }

    protected void playWithFile(File file) {
        preparePlayerService();

        File currentFile = getCurrentFile();
        if (currentFile != null && currentFile.pk == file.pk) {
            if (!isPlaying()) play();
            return;
        }

        currentPosition = getFilePosition(file);
        this.player.prepare(concatenatingMediaSource);
        this.player.seekTo(currentPosition, (long) file.currentTime);
        this.player.setPlayWhenReady(true);

    }

    protected void removeFromPlayList(File file) {

        int pos = getFilePosition(file);
        if (pos != -1) {
            this.files.remove(pos);
            concatenatingMediaSource.removeMediaSource(pos);
        }
    }

    private int getFilePosition(File file) {
        for (int i = 0; i < this.files.size(); i++) {
            if (this.files.get(i).pk == file.pk) {
                return i;
            }
        }
        addFileToList(file);
        return getFilePosition(file);
    }

    protected void emptyPlayList() {
        concatenatingMediaSource.clear();
        files.clear();
        this.player.prepare(concatenatingMediaSource);
    }

    protected void fastForward() {

        this.changeCurrentTime(this.getCurrentTime() + 15);
    }

    protected void fastBackward() {

        this.changeCurrentTime(this.getCurrentTime() - 5);
    }

    private void preparePlayerService() {
        if (AzPlayerPlugin.Companion.getInstance().isAllowToBindAudioService()) {
            this.setupPlayer();
            AzPlayerPlugin.Companion.getInstance().bindService();
            this.player.seekToDefaultPosition(currentPosition);
        }
    }

    protected void play() {

        preparePlayerService();
        this.player.setPlayWhenReady(true);
    }

    protected void stop() {

        this.player.stop();
        AzPlayerPlugin.Companion.getInstance().unBoundService();
    }


    private void setupPlayer() {

        this.player.prepare(concatenatingMediaSource);
        this.player.addListener(new Player.EventListener() {

            @Override
            public void onTimelineChanged(Timeline timeline, @androidx.annotation.Nullable Object manifest, int reason) {
                Log.d("PositionDiscontinuity", String.valueOf(reason));
            }

            @Override
            public void onPositionDiscontinuity(int reason) {
                Log.d("PositionDiscontinuity", String.valueOf(reason));
            }

            @Override
            public void onLoadingChanged(boolean isLoading) {

            }

            @Override
            public void onTracksChanged(TrackGroupArray trackGroups, TrackSelectionArray trackSelections) {

            }

            @Override
            public void onRepeatModeChanged(int repeatMode) {

            }

            @Override
            public void onShuffleModeEnabledChanged(boolean shuffleModeEnabled) {

            }

            @Override
            public void onPlayerError(ExoPlaybackException error) {

            }

            @Override
            public void onPlaybackParametersChanged(PlaybackParameters playbackParameters) {

            }

            @Override
            public void onSeekProcessed() {
                Log.d("PositionDiscontinuity", "seeked");

            }

            @Override
            public void onPlayerStateChanged(boolean playWhenReady, int playbackState) {
                if (playbackState == Player.STATE_BUFFERING) {
                    Log.i("player", "bufferingUpdate");
                } else if (playWhenReady && playbackState == Player.STATE_READY) {
                    initialView();
                    Log.i("player", "play");
                } else if (!playWhenReady && playbackState == Player.STATE_READY) {
                    initialView();
                    Log.i("player", "pause");
                } else if (playbackState == Player.STATE_IDLE) {
                    AzPlayerPlugin.Companion.getInstance().unBoundService();
                    Log.i("player", "stop");
                }
            }
        });
    }


    public SimpleExoPlayer getPlayer() {
        return this.player;
    }

    private void setPlaylist(List<File> files) {

        for (int i = 0; i < files.size(); i++) {
            String fileUrl = files.get(i).fileURL;
            Uri uri = Uri.parse(fileUrl);

            DataSource.Factory dataSourceFactory;
            boolean isInternetUrl = URLUtil.isHttpsUrl(fileUrl) || URLUtil.isHttpUrl(fileUrl);

            if (!isInternetUrl) {
                dataSourceFactory = new DefaultDataSourceFactory(context, "ExoPlayer");
            } else {
                dataSourceFactory = new DefaultHttpDataSourceFactory("ExoPlayer", null,
                        DefaultHttpDataSource.DEFAULT_CONNECT_TIMEOUT_MILLIS,
                        DefaultHttpDataSource.DEFAULT_READ_TIMEOUT_MILLIS, true);
            }

            MediaSource mediaSource = buildMediaSource(uri, dataSourceFactory, context);
            concatenatingMediaSource.addMediaSource(mediaSource);
        }
        if (!isPlaying())
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
