//
//  HomeScreenState.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import Foundation

@Observable
final class HomeScreenState {
    var today: Date = Calendar.current.startOfDay(for: Date())
    var selectedMood: Int16 = 3
    var selectedTags: [MoodTagModel] = []
    var allTags: [MoodTagModel] = []
    var note: String = ""
    var isMoodSavedToday: Bool = false

}
