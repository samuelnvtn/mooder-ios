//
//  StatsScreenState.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

//  StatsScreenState.swift
//  Mooder

import Foundation

@Observable
final class StatsScreenState {
    var chartMode: ChartMode = .bar
    var moodData: [MoodEntry] = []

    var averageMoodLabel: String = ""
    var averageMoodEmoji: String = ""
    var bestWeekText: String = ""
    var worstWeekText: String = ""
    var streakText: String = ""
}

// Pomocník na mapování nálady na emoji a popis
struct MoodLabelMapper {
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

    static func label(for mood: Int16) -> String {
        switch mood {
        case 5: return "Happy"
        case 4: return "Okay"
        case 3: return "Neutral"
        case 2: return "Meh"
        case 1: return "Sad"
        default: return "Unknown"
        }
    }
}
