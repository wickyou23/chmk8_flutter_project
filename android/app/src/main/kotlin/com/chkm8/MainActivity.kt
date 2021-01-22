package com.chkm8

import android.os.Bundle
import com.chkm8.channel.UtilsChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        UtilsChannel.configChannel(this.context, flutterEngine)
    }
}
