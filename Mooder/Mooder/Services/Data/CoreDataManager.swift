//
//  CoreDataManager.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

import CoreData

final class CoreDataManager: MoodDataManaging {
    private let container = NSPersistentContainer(name: "Mooder")

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Cannot create persistent store: \(error.localizedDescription)")
            }
        }
    }

    func saveMood(entry: MoodEntry) {
        save()
    }

    func fetchAllTags() -> [MoodTag] {
        let request = NSFetchRequest<MoodTag>(entityName: "MoodTag")
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Failed to fetch tags: \(error.localizedDescription)")
            return []
        }
    }

    
    func removeMood(entry: MoodEntry) {
        context.delete(entry)
        save()
    }

    func fetchAllMoods() -> [MoodEntry] {
        let request = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Cannot fetch moods: \(error.localizedDescription)")
            return []
        }
    }

    func fetchMoodForToday() -> MoodEntry? {
        let request = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        let calendar = Calendar.current
        let now = Date()

        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)

        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Cannot fetch today's mood: \(error.localizedDescription)")
            return nil
        }
    }
}

private extension CoreDataManager {
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Cannot save context: \(error.localizedDescription)")
            }
        }
    }
}
