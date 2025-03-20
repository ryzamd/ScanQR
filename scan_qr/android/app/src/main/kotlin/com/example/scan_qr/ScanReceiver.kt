package com.example.scan_qr

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.content.SharedPreferences
import android.content.pm.PackageManager

class ScanReceiver : BroadcastReceiver() {
    // Constants for app flavors
    companion object {
        const val QC_MANAGER = "QC_MANAGER"
        const val WAREHOUSE_INBOUND = "WAREHOUSE_INBOUND"
        const val WAREHOUSE_OUTBOUND = "WAREHOUSE_OUTBOUND"
        const val ALL_FLAVORS = "ALL"
        
        // Map package suffixes to flavors
        val PACKAGE_SUFFIX_TO_FLAVOR = mapOf(
            ".qc" to QC_MANAGER,
            ".inbound" to WAREHOUSE_INBOUND,
            ".outbound" to WAREHOUSE_OUTBOUND
        )
    }

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
        
        // Xác định target app nào (QC, Inbound, Outbound) dựa vào các tham số hoặc cấu hình
        val targetFlavor = determineTargetFlavor(context, intent)
        
        // Xác định danh sách các ứng dụng đang chạy để gửi intent
        val runningApps = getRunningApps(context)
        
        if (runningApps.isEmpty()) {
            Log.d("ScanReceiver", "Không có ứng dụng nào đang chạy")
            return
        }
        
        for (appInfo in runningApps) {
            // Nếu target flavor là ALL hoặc khớp với flavor của app đang chạy
            if (targetFlavor == ALL_FLAVORS || targetFlavor == appInfo.flavor) {
                sendScanDataToApp(context, appInfo.packageName, finalScanData, appInfo.flavor)
                Log.d("ScanReceiver", "Đã gửi dữ liệu đến ${appInfo.packageName} (${appInfo.flavor})")
            }
        }
    }
    
    private fun determineTargetFlavor(context: Context, intent: Intent): String {
        // Có thể xác định target dựa vào nội dung dữ liệu scan hoặc intent extras
        // Mặc định gửi cho tất cả các ứng dụng
        return ALL_FLAVORS
    }
    
    private fun sendScanDataToApp(context: Context, packageName: String, scanData: String, flavor: String) {
        try {
            val intent = context.packageManager.getLaunchIntentForPackage(packageName)
            if (intent != null) {
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
                intent.putExtra("scan_data", scanData)
                intent.putExtra("is_from_scan_receiver", true)
                intent.putExtra("scan_timestamp", System.currentTimeMillis())
                intent.putExtra("target_flavor", flavor)
                context.startActivity(intent)
                Log.d("ScanReceiver", "Đã gửi intent đến $packageName ($flavor)")
            } else {
                Log.e("ScanReceiver", "Không tìm thấy launch intent cho $packageName")
            }
        } catch (e: Exception) {
            Log.e("ScanReceiver", "Lỗi khi gửi intent đến $packageName: ${e.message}")
        }
    }

    private fun getRunningApps(context: Context): List<AppInfo> {
        val result = mutableListOf<AppInfo>()
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            
            // Base package name prefix for all three apps
            val basePackage = context.packageName.substringBefore(".qc")
                .substringBefore(".inbound")
                .substringBefore(".outbound")
            
            // Kiểm tra từng package có thể
            for ((suffix, flavor) in PACKAGE_SUFFIX_TO_FLAVOR) {
                val packageName = "$basePackage$suffix"
                if (isPackageInstalled(context, packageName) && 
                   isAppRunningInForeground(context, packageName, activityManager)) {
                    result.add(AppInfo(packageName, flavor))
                    Log.d("ScanReceiver", "App $packageName ($flavor) đang chạy")
                }
            }
        } catch (e: Exception) {
            Log.e("ScanReceiver", "Error checking running apps: ${e.message}")
        }
        return result
    }
    
    private fun isPackageInstalled(context: Context, packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun isAppRunningInForeground(context: Context, packageName: String, activityManager: ActivityManager
    ): Boolean {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+
                val runningProcesses = activityManager.runningAppProcesses ?: return false
                return runningProcesses.any {
                    it.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                    it.pkgList.contains(packageName)
                }
            } else {
                // Android 9 hoặc thấp hơn
                val appProcesses = activityManager.runningAppProcesses ?: return false
                for (appProcess in appProcesses) {
                    if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                        appProcess.processName == packageName) {
                        return true
                    }
                }
                return false
            }
        } catch (e: Exception) {
            Log.e("ScanReceiver", "Error checking app state for $packageName: ${e.message}")
            return false
        }
    }

    private fun saveScanData(context: Context, scanData: String) {
        val sharedPreferences = context.getSharedPreferences("ScanDataPrefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("last_scan_data", scanData.trim()).apply()
        Log.d("ScanReceiver", "Đã lưu dữ liệu vào SharedPreferences: $scanData")
    }
    
    // Helper class to store app info
    data class AppInfo(val packageName: String, val flavor: String)
}