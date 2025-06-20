//
//  TagSeeder.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//
import CoreData

struct TagSeeder {
    static func seedDefaultTags(into context: NSManagedObjectContext) {
        let tags: [(String, String)] = [
            ("Alcohol", "wineglass"),
            ("Illness", "cross.case"),
            ("Friends", "person.2"),
            ("Work", "briefcase"),
            ("Overthinking", "brain.head.profile"),
            ("Bad weather", "cloud.rain")
        ]

        for (name, icon) in tags {
            let tag = MoodTag(context: context)
            tag.id = UUID()
            tag.name = name
            tag.icon = icon
        }

        try? context.save()
    }
}
