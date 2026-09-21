package com.solopreneur.astrobite

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class AstroBiteWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.astrobite_widget).apply {
                // Read synced data from SharedPreferences
                val remaining = widgetData.getInt("remaining_calories", 2000)
                val consumed = widgetData.getInt("consumed_calories", 0)
                val target = widgetData.getInt("target_calories", 2000)
                val carbs = widgetData.getInt("carbs_grams", 0)
                val protein = widgetData.getInt("protein_grams", 0)
                val fat = widgetData.getInt("fat_grams", 0)
                val streak = widgetData.getInt("current_streak", 0)

                val targetSafe = if (target > 0) target else 2000
                val progressPercent = ((consumed.toDouble() / targetSafe.toDouble()) * 100).toInt().coerceIn(0, 100)

                // Bind to views
                setTextViewText(R.id.widget_remaining_calories, String.format("%,d", remaining))
                setProgressBar(R.id.widget_calorie_progress, 100, progressPercent, false)
                setTextViewText(
                    R.id.widget_consumed_progress,
                    "Đã nạp: ${String.format("%,d", consumed)} / ${String.format("%,d", target)} kcal"
                )
                setTextViewText(R.id.widget_streak, "🔥 $streak ngày")
                setTextViewText(R.id.widget_carbs, "${carbs}g")
                setTextViewText(R.id.widget_protein, "${protein}g")
                setTextViewText(R.id.widget_fat, "${fat}g")

                // Open App on Container Click
                val appPendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, appPendingIntent)

                // 1-Tap Quick Scan Click -> Deep link astrobite://scanner
                val scanPendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("astrobite://scanner")
                )
                setOnClickPendingIntent(R.id.widget_btn_scan, scanPendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
