package com.unisoftapps.tongaweatherforecast

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.unisoftaps.tongaweatherforecast/widget"
    private var widgetLaunchDetected = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidget" -> {
                        try {
                            val weatherData = mutableMapOf<String, String>()
                            weatherData["cityName"] = call.argument<String>("cityName") ?: "Unknown"
                            weatherData["temperature"] = call.argument<String>("temperature") ?: "--"
                            weatherData["condition"] = call.argument<String>("condition") ?: "Loading..."
                            weatherData["iconUrl"] = call.argument<String>("iconUrl") ?: ""
                            weatherData["minTemp"] = call.argument<String>("minTemp") ?: "--"
                            weatherData["maxTemp"] = call.argument<String>("maxTemp") ?: "--"

                            updateAllWidgets(weatherData)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("UPDATE_ERROR", "Failed to update widget: ${e.message}", null)
                        }
                    }
                    "isWidgetActive" -> {
                        val isActive = isWidgetActive()
                        result.success(isActive)
                    }
                    "requestPinWidget" -> {
                        try {
                            val success = requestPinWidget()
                            result.success(success)
                        } catch (e: Exception) {
                            result.error("PIN_WIDGET_ERROR", "Failed to request widget pin: ${e.message}", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == "ACTION_FROM_WIDGET") {
            widgetLaunchDetected = true
        }
    }

    override fun onResume() {
        super.onResume()
        if (widgetLaunchDetected) {
            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger!!, CHANNEL)
                .invokeMethod("widgetTapped", null)
            widgetLaunchDetected = false
        }
    }

    private fun updateAllWidgets(weatherData: Map<String, String>) {
        val context: Context = this
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, WeatherWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

        for (appWidgetId in appWidgetIds) {
            WeatherWidgetProvider.updateWidget(context, appWidgetManager, appWidgetId, weatherData)
        }
    }

    private fun isWidgetActive(): Boolean {
        val context: Context = this
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val componentName = ComponentName(context, WeatherWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
        return appWidgetIds.isNotEmpty()
    }

    private fun requestPinWidget(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val appWidgetManager = getSystemService(AppWidgetManager::class.java)
            if (appWidgetManager.isRequestPinAppWidgetSupported) {
                val provider = ComponentName(this, WeatherWidgetProvider::class.java)
                val pinnedWidgetCallbackIntent = Intent(this, javaClass)
                val successCallback = PendingIntent.getActivity(
                    this,
                    0,
                    pinnedWidgetCallbackIntent,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                )
                appWidgetManager.requestPinAppWidget(provider, null, successCallback)
                return true
            } else {
                Toast.makeText(this, "Pinning widgets not supported on this launcher.", Toast.LENGTH_SHORT).show()
            }
        } else {
            Toast.makeText(this, "Requires Android 8.0 or higher to pin widgets.", Toast.LENGTH_SHORT).show()
        }
        return false
    }
}
