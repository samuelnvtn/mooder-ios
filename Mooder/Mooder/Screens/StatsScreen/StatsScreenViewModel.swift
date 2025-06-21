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
    

}


enum ChartMode: String, CaseIterable, Identifiable {
    case bar, pie
    var id: String { rawValue }
}
