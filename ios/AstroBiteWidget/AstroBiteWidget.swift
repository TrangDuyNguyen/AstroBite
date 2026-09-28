import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            remainingCalories: 1500,
            consumedCalories: 500,
            targetCalories: 2000,
            carbs: 70,
            targetCarbs: 155,
            protein: 30,
            targetProtein: 120,
            fat: 16,
            targetFat: 50,
            streak: 3
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = fetchEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = fetchEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func fetchEntry() -> SimpleEntry {
        let prefs = UserDefaults(suiteName: "group.com.astrobite.app")
        let remaining = prefs?.integer(forKey: "remaining_calories") ?? 1500
        let consumed = prefs?.integer(forKey: "consumed_calories") ?? 500
        let target = prefs?.integer(forKey: "target_calories") ?? 2000
        let carbs = prefs?.integer(forKey: "carbs_grams") ?? 70
        let targetCarbs = max(1, prefs?.integer(forKey: "target_carbs_grams") ?? 155)
        let protein = prefs?.integer(forKey: "protein_grams") ?? 30
        let targetProtein = max(1, prefs?.integer(forKey: "target_protein_grams") ?? 120)
        let fat = prefs?.integer(forKey: "fat_grams") ?? 16
        let targetFat = max(1, prefs?.integer(forKey: "target_fat_grams") ?? 50)
        let streak = prefs?.integer(forKey: "current_streak") ?? 0

        return SimpleEntry(
            date: Date(),
            remainingCalories: remaining,
            consumedCalories: consumed,
            targetCalories: target,
            carbs: carbs,
            targetCarbs: targetCarbs,
            protein: protein,
            targetProtein: targetProtein,
            fat: fat,
            targetFat: targetFat,
            streak: streak
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let remainingCalories: Int
    let consumedCalories: Int
    let targetCalories: Int
    let carbs: Int
    let targetCarbs: Int
    let protein: Int
    let targetProtein: Int
    let fat: Int
    let targetFat: Int
    let streak: Int
}

struct AstroBiteWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(hex: "#1CB0F6"))
                    Text("ASTROBITE")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(Color(hex: "#1CB0F6"))
                }
                Spacer()
                Text("🔥 \(entry.streak) ngày")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#58CC02"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "#E8F9D8"))
                    .cornerRadius(10)
            }

            // Calorie summary & Scan button
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(entry.remainingCalories)")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(Color(hex: "#1E2337"))
                        Text("kcal còn lại")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(hex: "#78829A"))
                    }
                    Text("Đã nạp: \(entry.consumedCalories) / \(entry.targetCalories) kcal")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(Color(hex: "#78829A"))
                }
                Spacer()
                Link(destination: URL(string: "astrobite://scanner")!) {
                    HStack(spacing: 4) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 11))
                        Text("Quét AI")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#1CB0F6"))
                    .cornerRadius(12)
                }
            }

            // Macros Row
            HStack(spacing: 8) {
                MacroPill(label: "CARB", current: entry.carbs, target: entry.targetCarbs, color: Color(hex: "#1CB0F6"))
                MacroPill(label: "PROTEIN", current: entry.protein, target: entry.targetProtein, color: Color(hex: "#FF9600"))
                MacroPill(label: "FAT", current: entry.fat, target: entry.targetFat, color: Color(hex: "#FF5C8D"))
            }
        }
        .padding(14)
        .background(Color.white)
    }
}

struct MacroPill: View {
    let label: String
    let current: Int
    let target: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(Color(hex: "#78829A"))
            Text("\(current)g")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
            ProgressView(value: min(1.0, Double(current) / Double(max(1, target))))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(x: 1, y: 0.6, anchor: .center)
            Text("Mục tiêu \(target)g")
                .font(.system(size: 7.5))
                .foregroundColor(Color(hex: "#78829A"))
        }
        .padding(8)
        .background(Color(hex: "#F6F4F0"))
        .cornerRadius(12)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

@main
struct AstroBiteWidget: Widget {
    let kind: String = "AstroBiteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AstroBiteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AstroBite Widget")
        .description("Theo dõi nhanh lượng Calo và các chỉ số dinh dưỡng đa lượng.")
        .supportedFamilies([.systemMedium])
    }
}
