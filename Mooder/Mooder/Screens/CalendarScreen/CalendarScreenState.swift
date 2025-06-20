//
//  CalendarScreenState.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import Foundation

@Observable
final class CalendarScreenState {
    var moodDates: [Date: MoodEntry] = [:]
    var selectedDate: Date? = nil
    var selectedEntry: MoodEntry? = nil
}
