package com.iqonic.streamitlaravel

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class ScreenCaptureService : Service() {

    private var mediaProjection: MediaProjection? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val resultCode = intent?.getIntExtra("resultCode", 0)
        val data: Intent? = intent?.getParcelableExtra("data")

        if (resultCode != null && data != null) {
            val mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
            mediaProjection = mediaProjectionManager.getMediaProjection(resultCode, data)

            startForegroundService()
        }

        return START_NOT_STICKY
    }

    private fun startForegroundService() {
        val channelId = "ScreenCaptureServiceChannel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Screen Capture Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Screen Capture Service")
            .setContentText("Screen capture is running...")
            .setSmallIcon(R.drawable.ic_notification) // Replace with your notification icon
            .setContentIntent(getPendingIntent())
            .build()

        startForeground(1, notification)
    }

    private fun getPendingIntent(): PendingIntent {
        val notificationIntent = Intent(this, MainActivity::class.java)
        return PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaProjection?.stop()
    }
}
