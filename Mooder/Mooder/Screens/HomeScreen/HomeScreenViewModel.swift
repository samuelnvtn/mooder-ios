//
//  HomeScreenViewModel.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import Foundation
import SwiftUI

@Observable
class HomeScreenViewModel {
    var state = HomeScreenState()
    private let dataManager: MoodDataManaging
    private var calendarViewModel: CalendarScreenViewModel?

    init(dataManager: MoodDataManaging = CoreDataManager(), calendarViewModel: CalendarScreenViewModel? = nil) {
        self.dataManager = dataManager
        self.calendarViewModel = calendarViewModel
        loadToday()
    }

    let moodOptions: [(value: Int16, emoji: String, label: String)] = [
        (5, "😁", "Happy"),
        (4, "🙂", "Okay"),
        (3, "😐", "Neutral"),
        (2, "😕", "Meh"),
        (1, "😭", "Sad")
    ]

    var todayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }

    var groupedTags: [(String, [MoodTagModel])] {
        Dictionary(grouping: state.allTags, by: { $0.category })
            .sorted(by: { $0.key < $1.key })
            .map { ($0.key, $0.value) }
    }

    func selectMood(_ value: Int16) {
        state.selectedMood = value
    }

    func toggleTag(_ tag: MoodTagModel) {
        if state.selectedTags.contains(tag) {
            state.selectedTags.removeAll { $0 == tag }
        } else {
            state.selectedTags.append(tag)
        }
    }

    func loadToday() {
        state.today = Calendar.current.startOfDay(for: Date())
        state.allTags = dataManager.fetchAllTags().map { MoodTagModel(from: $0) }

        if let mood = dataManager.fetchMoodForToday(),
           let record = MoodRecord(from: mood) {
            state.selectedMood = record.mood
            state.selectedTags = record.tags
            state.note = record.note
            state.isMoodSavedToday = true
        } else {
            state.isMoodSavedToday = false
        }
    }


    func saveMood() {
        let entry = dataManager.fetchMoodForToday() ?? MoodEntry(context: dataManager.context)
        let record = MoodRecord(
            id: entry.id ?? UUID(),
            date: state.today,
            mood: state.selectedMood,
            note: state.note,
            tags: state.selectedTags
        )

        record.update(entry, using: dataManager.fetchAllTags())
        dataManager.saveMood(entry: entry)

        state.isMoodSavedToday = true
        calendarViewModel?.reloadData()
    }

}
