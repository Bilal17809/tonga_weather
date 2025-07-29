package com.unisoftapps.tonga_weather

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.graphics.BitmapFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.net.URL
import java.io.IOException

class MyAppWidgetProvider : AppWidgetProvider() {

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            weatherData: Map<String, String>
        ) {
            val views = RemoteViews(context.packageName, R.layout.my_widget_layout)

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
                action = "ACTION_FROM_WIDGET"
            }

            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            // 👉 Populate weather data
            views.setTextViewText(R.id.cityNameTextView, weatherData["cityName"] ?: "Unknown")
            views.setTextViewText(R.id.temperatureTextView, "${weatherData["temperature"] ?: "--"}°")
            views.setTextViewText(R.id.conditionTextView, weatherData["condition"] ?: "Loading...")
            views.setTextViewText(R.id.minMaxTextView, "${weatherData["maxTemp"] ?: "--"}°/${weatherData["minTemp"] ?: "--"}°")

            val iconUrl = weatherData["iconUrl"]
            if (!iconUrl.isNullOrEmpty()) {
                loadWeatherIcon(appWidgetManager, appWidgetId, views, iconUrl)
            } else {
                views.setImageViewResource(R.id.weatherIconImageView, R.drawable.ic_weather_default)
                appWidgetManager.updateAppWidget(appWidgetId, views)
            }
        }


        private fun loadWeatherIcon(
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            views: RemoteViews,
            iconUrl: String
        ) {
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val fullUrl = if (iconUrl.startsWith("//")) {
                        "https:$iconUrl"
                    } else if (iconUrl.startsWith("http")) {
                        iconUrl
                    } else {
                        "https://$iconUrl"
                    }

                    val bitmap = BitmapFactory.decodeStream(URL(fullUrl).openConnection().getInputStream())

                    CoroutineScope(Dispatchers.Main).launch {
                        views.setImageViewBitmap(R.id.weatherIconImageView, bitmap)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                } catch (e: IOException) {
                    CoroutineScope(Dispatchers.Main).launch {
                        views.setImageViewResource(R.id.weatherIconImageView, R.drawable.ic_weather_default)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
            }
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val defaultData = mapOf(
                "cityName" to "Loading...",
                "temperature" to "--",
                "condition" to "Updating...",
                "minTemp" to "--",
                "maxTemp" to "--",
                "iconUrl" to ""
            )
            updateWidget(context, appWidgetManager, appWidgetId, defaultData)
        }
    }
}