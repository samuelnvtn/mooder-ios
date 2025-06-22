//
//  MoodPieChartView.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

import SwiftUI
import Charts

struct MoodPieChartView: View {
    let moods: [MoodEntry]

    var body: some View {
        let counts = Dictionary(grouping: moods, by: { $0.mood })
        let pieEntries = counts.map { (key, value) in
            PieChartEntry(
                label: MoodLabelMapper.label(for: key),
                value: Double(value.count),
                moodValue: key
            )
        }

        return Chart(pieEntries, id: \.label) { entry in
            SectorMark(
                angle: .value("Count", entry.value),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(MoodLabelMapperr.color(for: entry.moodValue))
            .annotation(position: .overlay) {
                Text(MoodLabelMapperr.emoji(for: entry.moodValue))
                    .font(.caption)
            }
        }

        .frame(height: 250)
        .padding()
    }
}

struct PieChartEntry {
    let label: String
    let value: Double
    let moodValue: Int16
}

struct MoodLabelMapperr {
    static func emoji(for mood: Int16) -> String {
        switch mood {
        case 5: return "😁"
        case 4: return "🙂"
        case 3: return "😐"
        case 2: return "😕"
        case 1: return "😭"
        default: return "❓"
        }
    }

    static func color(for mood: Int16) -> Color {
        switch mood {
        case 5: return Color(hex: "#0F8977")
        case 4: return Color(hex: "#3CAF9B")
        case 3: return Color(hex: "#84BEB0")
        case 2: return Color(hex: "#FFB1A0")
        case 1: return Color(hex: "#FF8E9C")
        default: return .gray
        }
    }
}
