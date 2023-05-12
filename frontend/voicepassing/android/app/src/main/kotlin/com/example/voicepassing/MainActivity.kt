package com.example.voicepassing

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val callReceiver = object : EventChannel.StreamHandler, BroadcastReceiver() {
            var eventSink: EventChannel.EventSink? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            override fun onReceive(p0: Context?, p1: Intent?) {

                val state: String? = p1?.getStringExtra(TelephonyManager.EXTRA_STATE)
                val incomingNumber: String? =
                    p1?.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

                if(state.equals(TelephonyManager.EXTRA_STATE_RINGING)){
                    eventSink?.success("$incomingNumber")
                }
            }
        }

        registerReceiver(callReceiver, IntentFilter("android.intent.action.PHONE_STATE"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.app/callStream")
            .setStreamHandler(callReceiver)
    }
}
