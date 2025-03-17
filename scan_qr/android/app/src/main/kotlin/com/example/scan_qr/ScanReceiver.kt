package com.example.scan_qr

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.content.SharedPreferences

class ScanReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            Log.e("ScanReceiver", "Context or Intent is NULL")
            return
        }

        Log.d("ScanReceiver", "🔍 Broadcast Received!")

        val scanData = intent.getStringExtra("com.ubx.datawedge.data_string")
            ?: intent.getStringExtra("barcode_string")
            ?: intent.getStringExtra("urovo.rcv.message")
            ?: "No Scan Data Found"

        if (scanData == "No Scan Data Found") {
            Log.w("ScanReceiver", "Ignoring invalid scan data.")
            return
        }

        Log.d("ScanReceiver", "Valid Scanned Data: $scanData")

        saveScanData(context, scanData)

        val scanIntent = Intent(context, MainActivity::class.java)
        scanIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        scanIntent.putExtra("scan_data", scanData)
        context.startActivity(scanIntent)

        Log.d("ScanReceiver", "📡 Intent Sent to MainActivity with Valid Data")
    }

    private fun saveScanData(context: Context, scanData: String) {
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("ScanDataPrefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("last_scan_data", scanData.trim()).apply()
        Log.d("ScanReceivered", "Data saved: $scanData")
    }
}
