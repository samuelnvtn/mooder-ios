//
//  FirebaseSyncManager.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

import FirebaseFirestore
import FirebaseAuth

final class FirestoreSyncManager {
    private let db = Firestore.firestore()
    func uploadMood(_ entry: MoodEntry) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = entry.id else {
            print("❌ Mood entry has no ID!")
            return
        }

        // ✨ Připravíme pole slovníků pro každý tag
        let tagsArray = entry.tags?.compactMap { tag in
            guard let tag = tag as? MoodTag else { return nil }
            return [
                "name": tag.name ?? "",
                "icon": tag.icon ?? "",
                "category": tag.category ?? "",
                "id": tag.id?.uuidString ?? UUID().uuidString
            ]
        } ?? []

        // 🧾 Kompletní mood data včetně tagů
        let data: [String: Any] = [
            "mood": entry.mood,
            "date": entry.date ?? Date(),
            "note": entry.note ?? "",
            "tags": tagsArray
        ]

        // 📤 Upload do Firestore
        db.collection("users").document(uid)
            .collection("moods")
            .document(id.uuidString)
            .setData(data) { error in
                if let error = error {
                    print("❌ Upload mood failed: \(error.localizedDescription)")
                } else {
                    print("✅ Mood uploaded to Firebase with full tag data")
                }
            }
    }


    func fetchMoods(completion: @escaping ([MoodEntryData]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).collection("moods").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Fetch failed: \(error.localizedDescription)")
                completion([])
                return
            }

            let moods = snapshot?.documents.compactMap { doc -> MoodEntryData? in
                let data = doc.data()
                guard let mood = data["mood"] as? Int,
                      let timestamp = data["date"] as? Timestamp else {
                    return nil
                }
                return MoodEntryData(
                    id: UUID(uuidString: doc.documentID) ?? UUID(),
                    mood: mood,
                    date: timestamp.dateValue(),
                    note: data["note"] as? String ?? "",
                    tagDicts: data["tags"] as? [[String: Any]] // 💥 Přidat tohle
)
            } ?? []

            completion(moods)
        }
    }
}

struct MoodEntryData {
    let id: UUID
    let mood: Int
    let date: Date
    let note: String
    let tagDicts: [[String: Any]]?
}

