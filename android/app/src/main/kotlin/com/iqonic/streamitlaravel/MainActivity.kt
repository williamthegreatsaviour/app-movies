package com.iqonic.streamitlaravel

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//FlPiPActivity()
class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL: String = "flutter.iqonic.streamitlaravel.com.channel"
    private lateinit var channel: MethodChannel

    // New
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "showNativeView") {
                enablePictureInPicture(result)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode)

        // Notify Flutter about PiP mode changes
        channel.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
    }

    // Enables Picture-in-Picture mode
    private fun enablePictureInPicture(result: MethodChannel.Result) {
        try{
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val aspectRatio = Rational(16, 9)
                val pipBuilder = PictureInPictureParams.Builder()
                pipBuilder.setAspectRatio(aspectRatio)
                val isPipEnabled = enterPictureInPictureMode(pipBuilder.build())

                // Notify Flutter that PiP mode is enabled
                result.success(isPipEnabled)
            } else {
                result.success(false) // PiP is not supported on older versions
            }
        } catch (e: Exception) {
            // Handle any errors
            result.error("PIP_ERROR", "Failed to enter PiP mode", e.message)
        }
    }
}
