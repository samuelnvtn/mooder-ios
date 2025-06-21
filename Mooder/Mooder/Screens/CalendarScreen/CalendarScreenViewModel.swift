//
//  CalendarScreenViewModel.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import Foundation
import SwiftUI
import CoreData


class CalendarScreenViewModel: ObservableObject {
    @Published var state = CalendarScreenState()
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMoodEntries()
    }
    
    func select(date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        state.selectedDate = startOfDay
        state.selectedEntry = state.moodDates[startOfDay]
    }

    func fetchMoodEntries() {
        let request = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        do {
            let entries = try context.fetch(request)
            for entry in entries {
                if let date = entry.date {
                    let startOfDay = Calendar.current.startOfDay(for: date)
                    state.moodDates[startOfDay] = entry
                }
            }
        } catch {
            print("Failed to fetch mood entries: \(error)")
        }
    }

    func reloadData() {
        var newState = CalendarScreenState()
        newState.moodDates = [:]
        let request = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        do {
            let entries = try context.fetch(request)
            for entry in entries {
                if let date = entry.date {
                    let startOfDay = Calendar.current.startOfDay(for: date)
                    newState.moodDates[startOfDay] = entry
                }
            }
            newState.selectedDate = state.selectedDate
            newState.selectedEntry = newState.moodDates[state.selectedDate ?? Date()]
            self.state = newState 
            objectWillChange.send()
        } catch {
            print("❌ Failed to fetch mood entries: \(error)")
        }
    }
}
