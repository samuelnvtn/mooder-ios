//
//  GPTTipComponent.swift
//  Mooder
//
//  Created by Fietstopa on 22.06.2025.
//

import SwiftUI

struct GPTTipComponent: View {
    let moodEntries: [MoodEntry]
    @State private var tip: String? = nil
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                    .font(.title2)

                Text("Personalized Tip")
                    .font(.headline)
            }

            if isLoading {
                ProgressView("Getting your personal tip…")
            } else if let tip = tip {
                Text(tip)
                    .font(.body)
                    .foregroundColor(.primary)
            } else {
                Text("No tip available.")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            GPTService.shared.getAdvice(from: moodEntries) { result in
                DispatchQueue.main.async {
                    self.tip = result
                    self.isLoading = false
                }
            }
        }
    }
}
