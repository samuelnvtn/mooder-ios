//
//  DataManaging.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import CoreData

protocol MoodDataManaging {
    var context: NSManagedObjectContext { get }

    func saveMood(entry: MoodEntry)
    func removeMood(entry: MoodEntry)
    func fetchAllMoods() -> [MoodEntry]
    func fetchMoodForToday() -> MoodEntry?
    func fetchAllTags() -> [MoodTag]
    func saveSyncedMood(from mood: MoodEntryData)

}
