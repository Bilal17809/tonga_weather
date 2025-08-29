package com.unisoftapps.tongaweatherforecast

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.location.Location
import android.widget.RemoteViews
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.IOException
import java.net.URL

class WeatherWidgetProvider : AppWidgetProvider() {

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            weatherData: Map<String, String>
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

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

            views.setTextViewText(R.id.cityNameTextView, weatherData["cityName"] ?: "Unknown")
            views.setTextViewText(R.id.temperatureTextView, "${weatherData["temperature"] ?: "--"}°")
            views.setTextViewText(R.id.conditionTextView, weatherData["condition"] ?: "Loading...")
            views.setTextViewText(
                R.id.minMaxTextView,
                "${weatherData["maxTemp"] ?: "--"}°/${weatherData["minTemp"] ?: "--"}°"
            )

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
                    val fullUrl = when {
                        iconUrl.startsWith("//") -> "https:$iconUrl"
                        iconUrl.startsWith("http") -> iconUrl
                        else -> "https://$iconUrl"
                    }

                    val bitmap =
                        BitmapFactory.decodeStream(URL(fullUrl).openConnection().getInputStream())

                    CoroutineScope(Dispatchers.Main).launch {
                        views.setImageViewBitmap(R.id.weatherIconImageView, bitmap)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                } catch (e: IOException) {
                    CoroutineScope(Dispatchers.Main).launch {
                        views.setImageViewResource(
                            R.id.weatherIconImageView,
                            R.drawable.ic_weather_default
                        )
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        for (appWidgetId in appWidgetIds) {
            fetchAndUpdateWeather(context, appWidgetManager, appWidgetId)
        }
    }

    private fun fetchAndUpdateWeather(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val fusedLocationClient = LocationServices.getFusedLocationProviderClient(context)

        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                if (location != null) {
                    callWeatherApi(context, appWidgetManager, appWidgetId, location.latitude, location.longitude)
                } else {
                    callWeatherApi(context, appWidgetManager, appWidgetId, -21.1394, -175.2046)
                }
            }
            .addOnFailureListener {
                callWeatherApi(context, appWidgetManager, appWidgetId, -21.1394, -175.2046)
            }
    }

    private fun callWeatherApi(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        lat: Double,
        lon: Double
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val apiKey = "8e1b9cfeaccc48c4b2b85154230304"
                val days = 1
                val urlStr =
                    "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=$days&aqi=yes&alerts=no"

                val response = URL(urlStr).readText()
                val json = JSONObject(response)

                val location = json.getJSONObject("location")
                val current = json.getJSONObject("current")
                val forecastDay = json.getJSONObject("forecast")
                    .getJSONArray("forecastday")
                    .getJSONObject(0)
                    .getJSONObject("day")

                val weatherData = mapOf(
                    "cityName" to location.getString("name"),
                    "temperature" to current.getString("temp_c"),
                    "condition" to current.getJSONObject("condition").getString("text"),
                    "iconUrl" to current.getJSONObject("condition").getString("icon"),
                    "minTemp" to forecastDay.getString("mintemp_c"),
                    "maxTemp" to forecastDay.getString("maxtemp_c")
                )

                CoroutineScope(Dispatchers.Main).launch {
                    updateWidget(context, appWidgetManager, appWidgetId, weatherData)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                CoroutineScope(Dispatchers.Main).launch {
                    updateWidget(
                        context, appWidgetManager, appWidgetId, mapOf(
                            "cityName" to "Error",
                            "temperature" to "--",
                            "condition" to "Failed",
                            "iconUrl" to "",
                            "minTemp" to "--",
                            "maxTemp" to "--"
                        )
                    )
                }
            }
        }
    }
}