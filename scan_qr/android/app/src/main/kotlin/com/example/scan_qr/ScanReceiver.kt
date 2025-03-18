package com.example.scan_qr

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.content.SharedPreferences

class ScanReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) {
            Log.e("ScanReceiver", "Context or Intent is NULL")
            return
        }

        Log.d("ScanReceiver", "Broadcast Received! Action: ${intent.action}")
        
        // Trích xuất dữ liệu từ các intent khác nhau theo đúng action đã đăng ký
        var scanDataValue: String? = null
        
        when (intent.action) {
            "com.ubx.datawedge.SCANNER_DECODE_EVENT" -> { scanDataValue = intent.getStringExtra("com.ubx.datawedge.data_string")}
            "android.intent.ACTION_DECODE_DATA" -> { scanDataValue = intent.getStringExtra("barcode_string")}
            "urovo.rcv.message" -> { scanDataValue = intent.getStringExtra("urovo.rcv.message")}
        }
        
        // Nếu không tìm thấy trong action cụ thể, tìm trong tất cả extras
        if (scanDataValue == null) {
            intent.extras?.let { extras ->
                for (key in extras.keySet()) {
                    if (key.contains("data", ignoreCase = true) ||
                        key.contains("barcode", ignoreCase = true) ||
                        key.contains("scan", ignoreCase = true)) {
                        
                        val value = extras.getString(key)
                        if (value is String && value.isNotEmpty()) {
                            scanDataValue = value
                            Log.d("ScanReceiver", "Tìm thấy dữ liệu trong key $key: $value")
                            break
                        }
                    }
                }
            }
        }

        // Kiểm tra null và xử lý dữ liệu
        val finalScanData = scanDataValue
        if (finalScanData.isNullOrEmpty()) {
            Log.w("ScanReceiver", "Không tìm thấy dữ liệu quét hợp lệ")
            return
        }

        Log.d("ScanReceiver", "Dữ liệu quét hợp lệ: $finalScanData")
        
        // Lưu dữ liệu scan - sử dụng finalScanData có kiểu không null
        saveScanData(context, finalScanData)
        
        // Kiểm tra xem app đang chạy không
        if (isAppRunningInForeground(context)) {
            // App đang chạy và đang ở foreground - gửi intent tới MainActivity
            val mainIntent = Intent(context, MainActivity::class.java)
            mainIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            mainIntent.putExtra("scan_data", finalScanData)
            mainIntent.putExtra("is_from_scan_receiver", true)
            mainIntent.putExtra("scan_timestamp", System.currentTimeMillis())
            context.startActivity(mainIntent)
            Log.d("ScanReceiver", "Đã gửi intent đến MainActivity")
        } else {
            // App không chạy hoặc không ở foreground - không làm gì cả
            Log.d("ScanReceiver", "App không ở foreground, không gửi intent")
        }
    }

    private fun isAppRunningInForeground(context: Context): Boolean {
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+
                val runningProcesses = activityManager.runningAppProcesses ?: return false
                return runningProcesses.any {
                    it.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                    it.pkgList.contains(context.packageName)
                }
            } else {
                // Android 9 hoặc thấp hơn
                val appProcesses = activityManager.runningAppProcesses ?: return false
                val packageName = context.packageName
                for (appProcess in appProcesses) {
                    if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                        appProcess.processName == packageName) {
                        return true
                    }
                }
                return false
            }
        } catch (e: Exception) {
            Log.e("ScanReceiver", "Error checking app state: ${e.message}")
            return false
        }
    }

    private fun saveScanData(context: Context, scanData: String) {
        val sharedPreferences = context.getSharedPreferences("ScanDataPrefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("last_scan_data", scanData.trim()).apply()
        Log.d("ScanReceiver", "Đã lưu dữ liệu vào SharedPreferences: $scanData")
    }
}