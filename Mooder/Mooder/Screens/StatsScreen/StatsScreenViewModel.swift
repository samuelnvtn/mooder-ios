//
//  StatsScreenViewModel.swift
//  Mooder
//
//  Created by ROMSKY KRAL  on 20.06.2025.
//


import Foundation

@Observable
class StatsScreenViewModel {
    var state = StatsScreenState()
    private let dataManager: MoodDataManaging

    init(dataManager: MoodDataManaging = CoreDataManager()) {
        self.dataManager = dataManager
    }

    func loadData() {
        let moods = dataManager.fetchAllMoods()
        state.moodData = moods

        // Výpočet průměrné nálady
        let values = moods.map { $0.mood }
        if let avg = values.average {
            state.averageMoodLabel = MoodLabelMapper.label(for: avg)
            state.averageMoodEmoji = MoodLabelMapper.emoji(for: avg)
        }

        // Best/Worst týden - zjednodušené verze
        state.bestWeekText = "🎉 March 12 – Excited"
        state.worstWeekText = "😭 March 5 – Disappointed"
        state.streakText = "🔥 5 days feeling good or better"
    }
    
    func loadMockData() {
        let sampleDates = (0..<14).map {
            Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -$0, to: Date())!)
        }
        let sampleMoods: [Int16] = [5, 4, 5, 3, 2, 1, 4, 5, 5, 3, 4, 2, 1, 3]

        // Smaž předchozí data, pokud chceš čistý testovací výstup
        state.moodData.removeAll()

        for (date, mood) in zip(sampleDates, sampleMoods) {
            let entry = MoodEntry(context: dataManager.context)
            entry.id = UUID()
            entry.date = date
            entry.mood = mood
            entry.note = "Mock note for mood \(mood)"
            // entry.addToTags(...) pokud chceš testovací tagy

            state.moodData.append(entry)
        }

        // Výpočet průměru a výstupy
        let averageMood = Double(sampleMoods.reduce(0, +)) / Double(sampleMoods.count)
        let roundedMood = Int16(averageMood.rounded())
        state.averageMoodLabel = MoodLabelMapper.label(for: roundedMood)
        state.averageMoodEmoji = MoodLabelMapper.emoji(for: roundedMood)

        state.bestWeekText = "🌈 April 15–21 – Joyful"
        state.worstWeekText = "💀 April 1–7 – Miserable"
        state.streakText = "🔥 4 days feeling good or better"
    }



}


enum ChartMode: String, CaseIterable, Identifiable {
    case bar, pie
    var id: String { rawValue }
}
