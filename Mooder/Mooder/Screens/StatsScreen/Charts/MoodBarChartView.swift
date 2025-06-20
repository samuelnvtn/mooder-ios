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

    var body: some View {
        let grouped = Dictionary(grouping: moods) { entry -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "d.M."
            return formatter.string(from: entry.date ?? Date())
        }

        let bars: [BarChartEntry] = grouped
            .sorted { $0.key < $1.key }
            .map { (date, entries) in
                let avgMood = entries.map(\.mood).average ?? 3
                return BarChartEntry(value: Double(avgMood), label: date)
            }

        Chart(bars, id: \.label) { entry in
            BarMark(
                x: .value("Date", entry.label),
                y: .value("Average Mood", entry.value)
            )
            .foregroundStyle(by: .value("Mood", entry.value))
        }
        .frame(height: 200)
        .padding()
    }
}

struct BarChartEntry {
    let value: Double
    let label: String
}

extension Array where Element == Int16 {
    var average: Int16? {
        guard !isEmpty else { return nil }
        return Int16(Double(self.reduce(0, +)) / Double(self.count))
    }
}
