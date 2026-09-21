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
                val remaining = widgetData.getInt("remaining_calories", 1501)
                val consumed = widgetData.getInt("consumed_calories", 550)
                val target = widgetData.getInt("target_calories", 2051)
                val carbs = widgetData.getInt("carbs_grams", 70)
                val targetCarbs = widgetData.getInt("target_carbs_grams", 155).coerceAtLeast(1)
                val protein = widgetData.getInt("protein_grams", 30)
                val targetProtein = widgetData.getInt("target_protein_grams", 120).coerceAtLeast(1)
                val fat = widgetData.getInt("fat_grams", 16)
                val targetFat = widgetData.getInt("target_fat_grams", 50).coerceAtLeast(1)
                val streak = widgetData.getInt("current_streak", 0)

                val targetSafe = if (target > 0) target else 2000
                val progressPercent = ((consumed.toDouble() / targetSafe.toDouble()) * 100).toInt().coerceIn(0, 100)
                val carbsProgress = ((carbs.toDouble() / targetCarbs.toDouble()) * 100).toInt().coerceIn(0, 100)
                val proteinProgress = ((protein.toDouble() / targetProtein.toDouble()) * 100).toInt().coerceIn(0, 100)
                val fatProgress = ((fat.toDouble() / targetFat.toDouble()) * 100).toInt().coerceIn(0, 100)

                // Header & Calories
                setTextViewText(R.id.widget_streak, "🔥 $streak ngày")
                setTextViewText(R.id.widget_remaining_calories, String.format("%,d", remaining))
                setTextViewText(
                    R.id.widget_consumed_progress,
                    "Đã nạp: ${String.format("%,d", consumed)} / ${String.format("%,d", target)} kcal"
                )
                setTextViewText(R.id.widget_calorie_pct, "$progressPercent%")
                setProgressBar(R.id.widget_calorie_progress, 100, progressPercent, false)

                // Macro: Carbs
                setTextViewText(R.id.widget_carbs_val, "$carbs g")
                setTextViewText(R.id.widget_carbs_target, "Mục tiêu ${targetCarbs}g")
                setProgressBar(R.id.widget_carbs_progress, 100, carbsProgress, false)

                // Macro: Protein
                setTextViewText(R.id.widget_protein_val, "$protein g")
                setTextViewText(R.id.widget_protein_target, "Mục tiêu ${targetProtein}g")
                setProgressBar(R.id.widget_protein_progress, 100, proteinProgress, false)

                // Macro: Fat
                setTextViewText(R.id.widget_fat_val, "$fat g")
                setTextViewText(R.id.widget_fat_target, "Mục tiêu ${targetFat}g")
                setProgressBar(R.id.widget_fat_progress, 100, fatProgress, false)

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
