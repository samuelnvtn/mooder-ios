//
//  TagSeeder.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import CoreData

struct TagSeeder {
    static func seedDefaultTags(into context: NSManagedObjectContext) {
        let tags: [(name: String, icon: String, category: String)] = [
            ("Alcohol", "wineglass", "Body & health"),
            ("Illness", "cross.case", "Body & health"),
            ("Friends", "person.2", "Relationships"),
            ("Work", "briefcase", "Stress"),
            ("Overthinking", "brain.head.profile", "Thoughts & mind"),
            ("Bad weather", "cloud.rain", "Others")
        ]

        for tagData in tags {
            let tag = MoodTag(context: context)
            tag.id = UUID()
            tag.name = tagData.name
            tag.icon = tagData.icon
            tag.category = tagData.category
        }

        try? context.save()
    }
}
