//
//  MoodPieChartView.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

// MoodPieChartView.swift
// Mooder
import SwiftUI
import Charts

struct MoodPieChartView: View {
    let moods: [MoodEntry]

    var body: some View {
        let counts = Dictionary(grouping: moods, by: { $0.mood })
        let pieEntries = counts.map { (key, value) in
            return PieChartEntry(label: MoodLabelMapper.label(for: key), value: Double(value.count))
        }

        return Chart(pieEntries, id: \.label) { entry in
            SectorMark(
                angle: .value("Count", entry.value),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(by: .value("Mood", entry.label))
        }
        .frame(height: 250)
        .padding()
    }
}

struct PieChartEntry {
    let label: String
    let value: Double
}
