package pro.zahedi.flutter.plugin.player.az_player_plugin

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.os.IBinder

import java.lang.reflect.Type
import java.util.ArrayList

import io.flutter.Log
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener
import io.flutter.view.FlutterNativeView

/**
 * AzPlayerPlugin
 */
class AzPlayerPlugin private constructor(private val registrar: Registrar) : MethodCallHandler, ViewDestroyListener {
    private var audioServiceBinder: AudioServiceBinder? = null

    val isAllowToBindAudioService: Boolean
        get() = audioServiceBinder == null

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(componentName: ComponentName, iBinder: IBinder) {
            //            Log.i("ServiceConnnection", "Service connection audio service binder");
            audioServiceBinder = iBinder as AudioServiceBinder
            audioServiceBinder!!.create(registrar.context())
            //            Log.i("ServiceConnnection", "Service connection audio service binder complete");
        }

        override fun onServiceDisconnected(componentName: ComponentName) {
            //            Log.i("ServiceConnnection", "Service disconnected");

        }
    }

    init {
        PlayerService.getInstance(registrar.context())
        //        bindService();
        //        PlayerService.getInstance().stop();
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "duration" -> {

                result.success(PlayerService.getInstance().totalTime)
            }
            "currentTime" -> {
                result.success(PlayerService.getInstance().currentTime)
            }
            "secondsLeft" -> {
                result.success(PlayerService.getInstance().totalTime - PlayerService.getInstance().currentTime)
            }
            "currentFile" -> {
                val current = PlayerService.getInstance().currentFile
                if (current != null)
                    result.success(current.pk)
                else {
                    result.success(null)
                }
            }
            "isPlaying" -> {
                result.success(PlayerService.getInstance().isPlaying)
            }
            "play" -> {
                PlayerService.getInstance().play()
                result.success(true)
            }
            "playWithFile" -> {
                val filesJson = call.arguments as Map<String, Any>
                PlayerService.getInstance().playWithFile(File.fromJson(filesJson))
                result.success(true)
            }
            "pause" -> {
                PlayerService.getInstance().pause()
                result.success(true)
            }
            "stop" -> {
                PlayerService.getInstance().stop()
                result.success(true)
            }
            "addFileToPlayList" -> {
                val filesJson = call.arguments as Map<String, Any>
                PlayerService.getInstance().addFileToList(File.fromJson(filesJson))
                result.success(true)
            }
            "addFilesToPlayList" -> {
                val files = ArrayList<File>()
                val filesJson = call.arguments as List<Map<String, Any>>
                for (i in filesJson.indices) {
                    files.add(File.fromJson(filesJson[i]))
                }
                PlayerService.getInstance().addFilesToList(files)
                result.success(true)
            }
            "emptyPlayList" -> {
                PlayerService.getInstance().emptyPlayList()
                result.success(true)
            }
            "removeFromPlayList" -> {
                val filesJson = call.arguments as Map<String, Any>
                PlayerService.getInstance().removeFromPlayList(File.fromJson(filesJson))
                result.success(true)
            }
            "setImagePlaceHolder" -> {
                val filePath = call.arguments.toString()

                try {
                    val key = registrar.lookupKeyForAsset(filePath)
                    PlayerService.getInstance().setImagePlaceHolderPath(key)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }

            }
            "getPlayList" -> {
            }//TODO : ?
            "next" -> {
                PlayerService.getInstance().playNext()
                result.success(true)
            }
            "previous" -> {
                PlayerService.getInstance().playBackward()
                result.success(true)
            }
            "fastForward" -> {
                PlayerService.getInstance().fastForward()
                result.success(true)
            }
            "fastBackward" -> {
                PlayerService.getInstance().fastBackward()
                result.success(true)
            }
            "changeTime" -> {
                PlayerService.getInstance().changeCurrentTime(java.lang.Double.parseDouble(call.arguments.toString()))
                result.success(true)
            }
            "setRepeatMode" -> {
                PlayerService.getInstance().setPlayMode(PlayModeEnum.mode(call.arguments.toString()))
                result.success(true)
            }
            "changeScreenSize" -> {
                val sizeJson = call.arguments as Map<String, Any>
                val width = java.lang.Double.parseDouble(sizeJson["width"].toString())
                val height = java.lang.Double.parseDouble(sizeJson["height"].toString())
                PlayerService.getInstance().setPlayerViewSize(width, height)
                result.success(true)
            }
        }
    }

    override fun onViewDestroy(flutterNativeView: FlutterNativeView): Boolean {
        unBoundService()
        return false
    }

    fun bindService() {

        if (this.isAllowToBindAudioService) {
            val intent = Intent(registrar.context(), AudioService::class.java)
            registrar.context().bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
        }
    }

    fun unBoundService() {
        if (!this.isAllowToBindAudioService) {
            audioServiceBinder!!.destroyAllPlayers()
            registrar.context().unbindService(serviceConnection)
            audioServiceBinder = null
        }
    }

    companion object {
        // Static and Volatile attribute.
        @Volatile
        private var instance: AzPlayerPlugin? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "az_player_plugin")
            channel.setMethodCallHandler(AzPlayerPlugin.getInstance(registrar))
            registrar.platformViewRegistry().registerViewFactory("PlayerView", FlutterPlayerViewFactory(registrar.messenger()))
        }

        // Static function.
        fun getInstance(): AzPlayerPlugin? {
            return AzPlayerPlugin.getInstance(null)
        }

        protected fun getInstance(registrar: Registrar?): AzPlayerPlugin? {
            // Double check locking principle.
            // If there is no instance available, create new one (i.e. lazy initialization).
            if (instance == null && registrar != null) {

                // To provide thread-safe implementation.
                synchronized(AzPlayerPlugin::class.java) {

                    // Check again as multiple threads can reach above step.
                    if (instance == null) {
                        instance = AzPlayerPlugin(registrar)
                    }
                }
            }
            return instance
        }
    }
}
