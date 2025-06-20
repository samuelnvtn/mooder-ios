// TagSeeder.swift

import CoreData

struct TagSeeder {
    static func seedDefaultTags(into context: NSManagedObjectContext) {
        let tags: [(name: String, icon: String, category: String)] = [
            // Původní tagy
            ("Alcohol", "wineglass", "Body & Health"),
            ("Illness", "cross.case", "Body & Health"),
            ("Friends", "person.2", "Relationships"),
            ("Work", "briefcase", "Stress"),
            ("Overthinking", "brain.head.profile", "Thoughts & Mind"),
            ("Bad Weather", "cloud.rain", "Others"),

            // Nové tagy pro "Body & Health"
            ("Sleep", "moon.fill", "Body & Health"),
            ("Exercise", "figure.walk", "Body & Health"),
            ("Healthy Food", "carrot.fill", "Body & Health"),
            ("Unhealthy Food", "fastfood.fill", "Body & Health"),
            ("Headache", "brain.head.profile", "Body & Health"),
            ("Energy", "bolt.fill", "Body & Health"),
            ("Fatigue", "bed.double.fill", "Body & Health"),

            // Nové tagy pro "Relationships"
            ("Family", "house.fill", "Relationships"),
            ("Partner", "heart.fill", "Relationships"),
            ("Pets", "pawprint.fill", "Relationships"),
            ("Conflict", "exclamationmark.triangle.fill", "Relationships"),
            ("Social Event", "person.3.fill", "Relationships"),
            ("Alone Time", "person.crop.circle.badge.minus", "Relationships"),

            // Nové tagy pro "Stress"
            ("Deadlines", "hourglass", "Stress"),
            ("Finances", "banknote.fill", "Stress"),
            ("Chores", "hand.raised.square.fill", "Stress"),
            ("Commute", "car.fill", "Stress"),
            ("Decision Making", "questionmark.circle.fill", "Stress"),

            // Nové tagy pro "Thoughts & Mind"
            ("Creativity", "lightbulb.fill", "Thoughts & Mind"),
            ("Productivity", "checkmark.circle.fill", "Thoughts & Mind"),
            ("Learning", "book.closed.fill", "Thoughts & Mind"),
            ("Anxiety", "sparkles", "Thoughts & Mind"), // Ikonka může být diskutabilní, ale je to obecná jiskra
            ("Mindfulness", "leaf.fill", "Thoughts & Mind"),

            // Nové tagy pro "Activities"
            ("Hobbies", "gamecontroller.fill", "Activities"),
            ("Reading", "book.fill", "Activities"),
            ("Music", "music.note", "Activities"),
            ("Travel", "airplane", "Activities"),
            ("Shopping", "bag.fill", "Activities"),
            ("Cooking", "frying.pan.fill", "Activities"),
            ("Nature", "tree.fill", "Activities"),

            // Nové tagy pro "Environment"
            ("Clean Space", "sparkle.magnifyingglass", "Environment"),
            ("Messy Space", "trash.fill", "Environment"),
            ("Quiet", "speaker.slash.fill", "Environment"),
            ("Noisy", "speaker.wave.3.fill", "Environment"),

            // Další (Others)
            ("Achievements", "trophy.fill", "Others"),
            ("Disappointments", "xmark.circle.fill", "Others"),
            ("Relaxation", "chair.fill", "Others"),
            ("Challenge", "figure.stairs", "Others")
        ]

        for tagData in tags {
            // Kontrola, zda tag s daným názvem již existuje, aby se zabránilo duplikátům
            let fetchRequest: NSFetchRequest<MoodTag> = MoodTag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", tagData.name)

            do {
                let existingTags = try context.fetch(fetchRequest)
                if existingTags.isEmpty {
                    let tag = MoodTag(context: context)
                    tag.id = UUID()
                    tag.name = tagData.name
                    tag.icon = tagData.icon
                    tag.category = tagData.category
                } else {
                    print("ℹ️ Tag '\(tagData.name)' already exists, skipping seeding.")
                }
            } catch {
                print("❌ Error checking for existing tag '\(tagData.name)': \(error.localizedDescription)")
            }
        }

        // Tuto metodu je lepší volat s `try context.save()` a ošetřit chybu jinde,
        // ale ponechávám `try?` pro konzistenci s tvým původním kódem.
        try? context.save()
    }
}
