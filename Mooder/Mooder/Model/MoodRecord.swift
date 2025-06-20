//
//  MoodRecord.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import Foundation

struct MoodRecord: Identifiable {
    var id: UUID
    var date: Date
    var mood: Int16
    var note: String
    var tags: [MoodTagModel]

    init?(from entity: MoodEntry) {
        guard let id = entity.id,
              let date = entity.date,
              let note = entity.note,
              let tagSet = entity.tags as? Set<MoodTag> else { return nil }

        self.id = id
        self.date = date
        self.mood = entity.mood
        self.note = note
        self.tags = tagSet.map { MoodTagModel(from: $0) }
    }

    func update(_ entity: MoodEntry, using contextTags: [MoodTag]) {
        entity.id = id
        entity.date = date
        entity.mood = mood
        entity.note = note

        let matchingTags = contextTags.filter { tag in
            tags.contains(where: { $0.id == tag.id })
        }
        entity.tags = NSSet(array: matchingTags)
    }
}
