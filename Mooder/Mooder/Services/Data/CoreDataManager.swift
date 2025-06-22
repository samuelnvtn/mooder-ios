// CoreDataManager.swift

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
            } else {
                // MARK: - Zde zavolejte funkci pro seeding dat
                self.seedInitialTagsIfNeeded() // Volání je správné
            }
        }
    }

    func saveMood(entry: MoodEntry) {
        if context.insertedObjects.contains(entry) == false {
            context.insert(entry)
        }
        save()
        
        // Upload do Firestore
        FirestoreSyncManager().uploadMood(entry)
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
    
    func fetchOnlySeededTags() -> [MoodTag] {
        let request = NSFetchRequest<MoodTag>(entityName: "MoodTag")
        request.predicate = NSPredicate(format: "isSeeded == true")
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Failed to fetch seeded tags: \(error)")
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

    func clearAllMoods() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MoodEntry")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("🧹 Cleared all local moods")
        } catch {
            print("❌ Failed to clear moods: \(error.localizedDescription)")
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
    
    func saveSyncedMood(from data: MoodEntryData) {
        let entry = MoodEntry(context: context)
        entry.id = data.id
        entry.mood = Int16(data.mood)
        entry.date = data.date
        entry.note = data.note

        // 💥 OPRAVA: Zpracujeme tagDicts
        if let tagDicts = data.tagDicts {
            let tags = tagDicts.compactMap { dict -> MoodTag? in
                let tag = MoodTag(context: context)
                tag.name = dict["name"] as? String ?? ""
                tag.icon = dict["icon"] as? String ?? ""
                tag.category = dict["category"] as? String ?? ""
                tag.id = UUID(uuidString: dict["id"] as? String ?? "") ?? UUID()
                return tag
            }

            entry.tags = NSSet(array: tags)
        }

        save()
    }


}

// --- Zde začíná private extension ---
private extension CoreDataManager {
    // Tato funkce byla přesunuta sem
    func seedInitialTagsIfNeeded() {
        do {
            let request = NSFetchRequest<MoodTag>(entityName: "MoodTag")
            let count = try context.count(for: request)

            if count == 0 { // Pouze pokud databáze neobsahuje žádné tagy
                TagSeeder.seedDefaultTags(into: context)
                print("✅ Default tags seeded successfully.")
            } else {
                print("ℹ️ Tags already exist, no seeding needed.")
            }
        } catch {
            print("❌ Error checking for existing tags: \(error.localizedDescription)")
        }
    }

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
