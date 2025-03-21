package com.example.scan_qr

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "com.example.scan_qr/scanner"
    private val METHOD_CHANNEL = "com.example.scan_qr/scanner_method"
    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    
    private var isInScannerPage = false
    
    // Thêm biến để theo dõi giá trị scan cuối cùng để tránh trùng lặp
    private var lastProcessedScan: String? = null
    private var lastProcessedTimestamp: Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "💫 MainActivity created")
        
        // Xử lý khi được khởi động bởi ScanReceiver
        if (intent?.getBooleanExtra("is_from_scan_receiver", false) == true) {
            handler.postDelayed({
                processIntent(intent)
            }, 1000) // Cho 1 giây để Flutter khởi động
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("MainActivity", "Cấu hình Flutter Engine")

        // Thiết lập EventChannel để gửi dữ liệu quét tới Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d("MainActivity", "EventChannel bắt đầu lắng nghe")
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d("MainActivity", "EventChannel dừng lắng nghe")
                }
            })
            
        // Thiết lập MethodChannel để Flutter thông báo khi vào/ra trang scanner
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enterScanPage" -> {
                    isInScannerPage = true
                    // Reset giá trị lần quét cuối cùng khi vào trang scan
                    lastProcessedScan = null
                    lastProcessedTimestamp = 0
                    Log.d("MainActivity", "Flutter thông báo: Đã vào trang scanner")
                    result.success(true)
                }
                "exitScanPage" -> {
                    isInScannerPage = false
                    Log.d("MainActivity", "Flutter thông báo: Đã rời trang scanner")
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "Nhận Intent mới: ${intent.action}")
        
        // Lưu và sử dụng intent mới
        setIntent(intent)
        
        // Chỉ xử lý intent khi đang ở trang scanner
        if (isInScannerPage) {
            processIntent(intent)
        } else {
            Log.d("MainActivity", "Không xử lý intent vì không ở trang scanner")
        }
    }
    
    private fun processIntent(intent: Intent) {
        // Không xử lý nếu đang không ở trang scanner
        if (!isInScannerPage) {
            Log.d("MainActivity", "Bỏ qua processIntent vì không ở trang scanner")
            return
        }
        
        // Kiểm tra timestamp để tránh xử lý trùng lặp
        val timestamp = intent.getLongExtra("scan_timestamp", System.currentTimeMillis())
        if (timestamp - lastProcessedTimestamp < 1000) {
            Log.d("MainActivity", "Bỏ qua vì quá gần với lần quét trước")
            return
        }
        
        val scanData = intent.getStringExtra("scan_data")
        if (scanData != null) {
            // Kiểm tra xem có phải giá trị trùng lặp không
            if (scanData == lastProcessedScan) {
                Log.d("MainActivity", "Bỏ qua dữ liệu trùng lặp: $scanData")
                return
            }
            
            Log.d("MainActivity", "Dữ liệu quét: $scanData")
            sendScanDataToFlutter(scanData)
            
            // Lưu lại giá trị vừa xử lý để tránh trùng lặp
            lastProcessedScan = scanData
            lastProcessedTimestamp = timestamp
        } else {
            Log.w("MainActivity", "Không tìm thấy dữ liệu quét trong intent")
            
            // Tìm kiếm trong tất cả extras nếu không có "scan_data"
            var foundData = false
            intent.extras?.keySet()?.forEach { key ->
                if (key.contains("data", ignoreCase = true) ||
                    key.contains("barcode", ignoreCase = true) ||
                    key.contains("scan", ignoreCase = true)) {
                    
                    val value = intent.extras?.getString(key)
                    if (value is String && value.isNotEmpty()) {
                        // Kiểm tra trùng lặp
                        if (value != lastProcessedScan) {
                            Log.d("MainActivity", "Tìm thấy dữ liệu quét trong key $key: $value")
                            sendScanDataToFlutter(value)
                            lastProcessedScan = value
                            lastProcessedTimestamp = timestamp
                            foundData = true
                            return@forEach
                        } else {
                            Log.d("MainActivity", "Bỏ qua dữ liệu trùng lặp trong key $key: $value")
                        }
                    }
                }
            }
            
            if (!foundData) {
                Log.d("MainActivity", "Không tìm thấy dữ liệu quét hợp lệ trong intent")
            }
        }
    }

    fun sendScanDataToFlutter(scanData: String) {
        if (!isInScannerPage) {
            Log.d("MainActivity", "Không gửi dữ liệu vì không ở trang scanner")
            return
        }
        
        if (eventSink == null) {
            Log.e("MainActivity", "EventSink là NULL, thử lại sau 500ms")
            // Nếu eventSink chưa sẵn sàng, thử lại sau 500ms
            handler.postDelayed({
                if (eventSink != null && isInScannerPage) {
                    eventSink?.success(scanData)
                    Log.d("MainActivity", "Đã gửi dữ liệu quét đến Flutter (retry): $scanData")
                } else {
                    Log.e("MainActivity", "EventSink vẫn NULL hoặc không ở trang scanner")
                }
            }, 500)
            return
        }

        handler.post {
            eventSink?.success(scanData)
            Log.d("MainActivity", "Đã gửi dữ liệu quét đến Flutter: $scanData")
        }
    }
}