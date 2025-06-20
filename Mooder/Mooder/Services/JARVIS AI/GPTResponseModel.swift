//
//  GPTResponseModel.swift
//  Mooder
//
//  Created by Fietstopa on 21.06.2025.
//

// GPTService.swift

import Foundation

final class GPTService {
    static let shared = GPTService()

    private let apiKey = "YOUR_OPENAI_API_KEY" // ⚠️ NEUKLÁDEJ TO TVRDĚ DO APPKY!
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    func getAdvice(from moodEntries: [MoodEntry], completion: @escaping (String?) -> Void) {
        let moodHistory = moodEntries
            .prefix(14) 
            .map { entry in
                let mood = entry.mood
                let note = entry.note ?? "žádná poznámka"
                let date = DateFormatter.localizedString(from: entry.date ?? Date(), dateStyle: .medium, timeStyle: .none)
                return "\(date): nálada \(mood) – \(note)"
            }
            .joined(separator: "\n")

        let prompt = """
        Tady je má náladová historie za poslední dny:
        \(moodHistory)

        Na základě toho mi prosím dej jednu konkrétní radu, jak zlepšit svůj den nebo náladu. Buď pozitivní a stručný.
        """

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are a helpful AI coach focused on emotional well-being."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.8
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
                  let message = response.choices.first?.message.content else {
                print("❌ GPT Error: \(error?.localizedDescription ?? "no response")")
                completion(nil)
                return
            }
            completion(message)
        }.resume()
    }
}
