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
    
    var allMoods: [MoodEntry] {
        dataManager.fetchAllMoods()
    }
    init(dataManager: MoodDataManaging = CoreDataManager()) {
        self.dataManager = dataManager
    }
    func loadData() {
        let moods = dataManager.fetchAllMoods()
        let weekDates = currentWeekDates()
        guard let start = weekDates.first, let end = weekDates.last else { return }

        state.moodData = moods.filter {
            guard let date = $0.date else { return false }
            return date >= start && date <= end
        }

        let values = state.moodData.map { $0.mood }
        if let avg = values.average {
            state.averageMoodLabel = MoodLabelMapper.label(for: avg)
            state.averageMoodEmoji = MoodLabelMapper.emoji(for: avg)
        }

        // Tady nová dynamika
        computeBestAndWorstWeeks(from: moods)
        computeMoodStreak(from: moods)
    }

    private func computeBestAndWorstWeeks(from moods: [MoodEntry]) {
        let groupedByWeek = Dictionary(grouping: moods) { $0.date?.startOfWeek() ?? Date.distantPast }
        let weekAverages = groupedByWeek.mapValues { entries in
            entries.map(\.mood).average ?? 0
        }

        guard let best = weekAverages.max(by: { $0.value < $1.value }),
              let worst = weekAverages.min(by: { $0.value < $1.value }) else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"

        state.bestWeekText = "🎉 \(formatter.string(from: best.key)) – \(MoodLabelMapper.label(for: best.value))"
        state.worstWeekText = "😭 \(formatter.string(from: worst.key)) – \(MoodLabelMapper.label(for: worst.value))"
    }


    private func computeMoodStreak(from moods: [MoodEntry]) {
        let sortedDates = moods.compactMap { $0.date }
            .sorted()
            .map { Calendar.current.startOfDay(for: $0) }

        let dateToMood: [Date: Int16] = Dictionary(uniqueKeysWithValues: moods.compactMap {
            guard let date = $0.date else { return nil }
            return (Calendar.current.startOfDay(for: date), $0.mood)
        })


        var maxStreak = 0
        var currentStreak = 0
        var lastDate: Date?

        for date in sortedDates {
            guard let mood = dateToMood[date] else { continue }

            if let last = lastDate, Calendar.current.date(byAdding: .day, value: 1, to: last) != date {
                currentStreak = 0 // přerušeno
            }

            if mood >= 4 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 0
            }

            lastDate = date
        }

        state.streakText = "🔥 \(maxStreak) day\(maxStreak == 1 ? "" : "s") feeling good or better"
    }

    func nextWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        loadData()
    }

    func previousWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart)!
        loadData()
    }
    
    private var allMoodDates: [Date] {
        dataManager.fetchAllMoods().compactMap { $0.date }
    }

    var canGoToPreviousWeek: Bool {
        guard let firstDate = allMoodDates.min() else { return false }
        return currentWeekStart > firstDate.startOfWeek()
    }

    var canGoToNextWeek: Bool {
        guard let lastDate = allMoodDates.max() else { return false }
        let nextWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        return nextWeekStart <= lastDate.startOfWeek()
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
