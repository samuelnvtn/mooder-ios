//
//  MoodBarChartView.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

// MoodBarChartView.swift
// Mooder
//
//  MoodBarChartView.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

import SwiftUI
import Charts


struct MoodBarChartView: View {
    let moods: [MoodEntry]
    let weekDates: [Date]

    var body: some View {
        let moodMap = Dictionary(grouping: moods, by: { Calendar.current.startOfDay(for: $0.date ?? Date()) })

        let bars: [BarChartEntry] = weekDates.map { date in
            let dayMoods = moodMap[Calendar.current.startOfDay(for: date)] ?? []
            let avgMood = dayMoods.map(\.mood).average ?? 0
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return BarChartEntry(value: Double(avgMood), label: formatter.string(from: date), mood: avgMood)
        }

        Chart(bars, id: \.label) { entry in
            BarMark(
                x: .value("Date", entry.label),
                y: .value("Mood", entry.value)
            )
            .foregroundStyle(moodColor(for: Int(entry.mood)))
        }
        .chartYScale(domain: 0...5) // fixnutý rozsah osy Y
        .chartYAxis {
            AxisMarks(position: .leading, values: [1, 2, 3, 4, 5]) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let intVal = value.as(Int.self) {
                        Text(moodEmoji(for: intVal))
                    }
                }
            }
        }

        .frame(height: 200)
        .padding()

    }
    
    func moodEmoji(for mood: Int) -> String {
        switch mood {
        case 5: return "😁"
        case 4: return "🙂"
        case 3: return "😐"
        case 2: return "😕"
        case 1: return "😭"
        default: return ""
        }
    }


    func moodColor(for mood: Int) -> Color {
        switch mood {
        case 5: return Color(hex: "#0F8977")
        case 4: return Color(hex: "#3CAF9B")
        case 3: return Color(hex: "#84BEB0")
        case 2: return Color(hex: "#FFB1A0")
        case 1: return Color(hex: "#FF8E9C")
        default: return .gray.opacity(0.3)
        }
    }

}

struct BarChartEntry {
    let value: Double
    let label: String
    let mood: Int16
}




extension Array where Element == Int16 {
    var average: Int16? {
        guard !isEmpty else { return nil }
        return Int16(Double(self.reduce(0, +)) / Double(self.count))
    }
}
