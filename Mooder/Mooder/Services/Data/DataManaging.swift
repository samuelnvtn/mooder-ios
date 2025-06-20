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

    func addSampleMood()
}

extension MoodDataManaging {
    func addSampleMood() {
        let today = Calendar.current.startOfDay(for: Date())
        let mood = MoodEntry(context: context)
        mood.id = UUID()
        mood.date = today
        mood.mood = 4 // Happy
        mood.note = "Sample entry"

        // Přidáme existující tagy náhodně (volitelně)
        let tagRequest = NSFetchRequest<MoodTag>(entityName: "MoodTag")
        if let tags = try? context.fetch(tagRequest), tags.count >= 2 {
            mood.addToTags(tags[0])
            mood.addToTags(tags[1])
        }

        saveMood(entry: mood)
    }
}
