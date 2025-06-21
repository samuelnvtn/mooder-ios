//
//  StatsScreenViewModel.swift
//  Mooder
//
//  Created by ROMSKY KRAL  on 20.06.2025.
//


import Foundation
class StatsScreenViewModel {
    var state = StatsScreenState()
    private let dataManager: MoodDataManaging
    private var currentWeekStart: Date = Date().startOfWeek()

    init(dataManager: MoodDataManaging = CoreDataManager()) {
        self.dataManager = dataManager
    }
    func loadData() {
        let moods = dataManager.fetchAllMoods()
        state.moodData = moods.filter {
            guard let date = $0.date else { return false }
            return Calendar.current.isDate(date, equalTo: currentWeekStart, toGranularity: .weekOfYear)
        }

        let values = state.moodData.map { $0.mood }
        if let avg = values.average {
            state.averageMoodLabel = MoodLabelMapper.label(for: avg)
            state.averageMoodEmoji = MoodLabelMapper.emoji(for: avg)
        }

        state.bestWeekText = "🎉 March 12 – Excited"
        state.worstWeekText = "😭 March 5 – Disappointed"
        state.streakText = "🔥 5 days feeling good or better"
    }

    func nextWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        loadData()
    }

    func previousWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart)!
        loadData()
    }
    
    func formattedCurrentWeekRange() -> String {
        let dates = currentWeekDates()
        guard let start = dates.first, let end = dates.last else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = "d.M."

        return "\(formatter.string(from: start)) – \(formatter.string(from: end))"
    }

    func currentWeekDates() -> [Date] {
        return (0..<7).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: currentWeekStart)
        }
    }
}

extension Date {
    func startOfWeek() -> Date {
        let cal = Calendar.current
        return cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}



enum ChartMode: String, CaseIterable, Identifiable {
    case bar, pie
    var id: String { rawValue }
}
