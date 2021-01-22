package com.chkm8.channel

import android.app.Application
import android.app.NotificationManager
import android.content.Context
import android.net.ConnectivityManager
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*
import java.util.logging.LogManager

private const val UTILS_CHANNEL_KEY  = "flutter.tp.utilsNativeChannel"

object UtilsFunctionName {
    const val GET_CITY_TIMEZONE = "getCityTimeZone"
    const val GET_PROXY_DEFAULT = "getProxyDefault"
    const val CANCEL_ALL_NOTIFICATION_TRAY = "cancelAllNotificationTray"
}

object UtilsChannel {
    fun configChannel(context: Context, flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UTILS_CHANNEL_KEY).setMethodCallHandler {
            call, result ->
            when (call.method) {
                UtilsFunctionName.GET_CITY_TIMEZONE -> {
                    result.success(this.getCityTimeZone())
                }
                UtilsFunctionName.GET_PROXY_DEFAULT -> {
                    result.success(this.getProxyDefault(context))
                }
                UtilsFunctionName.CANCEL_ALL_NOTIFICATION_TRAY -> {
                    this.cleanSystemTrayNotification(context)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getCityTimeZone(): String {
        Log.d("", "getCityTimeZone is running =========")
        return TimeZone.getDefault().id
    }

    private fun getProxyDefault(context: Context): String {
        Log.d("", "getProxyDefault is running =========")
        val cn = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        return "{\"host:\"${cn.defaultProxy.host}, \"port:\"${cn.defaultProxy.port}}"
    }

    private fun cleanSystemTrayNotification(context: Context) {
        Log.d("", "cleanSystemTrayNotification is running =========")
        val notificationManger = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        val activeNoti = notificationManger.activeNotifications
//        for (item: StatusBarNotification in activeNoti) {
//            val notiItem = item.notification
//            for (key: String in notiItem.extras.keySet()) {
//                val value = notiItem.extras.get(key)
//                if (value != null)  {
//                    Log.d(key, value.toString())
//                }
//                else {
//                    Log.d(key, "===========================")
//                }
//            }
//        }
        notificationManger.cancelAll()
    }
}