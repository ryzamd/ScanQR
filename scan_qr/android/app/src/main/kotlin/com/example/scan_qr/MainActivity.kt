package com.example.scan_qr

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "com.example.scan_qr/scanner"
    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d("MainActivity", "✅ EventChannel Listener Started")
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d("MainActivity", "❌ EventChannel Listener Stopped")
                }
            })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val scanData = intent.getStringExtra("scan_data")
        if (scanData != null) {
            sendScanDataToFlutter(scanData)
        }
    }

    fun sendScanDataToFlutter(scanData: String) {
        if (eventSink == null) {
            Log.e("MainActivity", "❌ EventSink is NULL, cannot send data!")
            return
        }

        handler.post {
            eventSink?.success(scanData)
            Log.d("MainActivity", "📡 Sending Scan Data to Flutter: $scanData")
        }
    }
}
