//
//  ModalDetailSheet.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import SwiftUI

struct MoodDetailSheet: View {
    let entry: MoodEntry

    @Environment(\.dismiss) private var dismiss
    @State private var shakeAngle: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notes and tags")
                    .font(.headline)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 8)

            if let note = entry.note, let tags = entry.tags as? Set<MoodTag> {
                HStack(spacing: 8) {
                    if !note.isEmpty {
                        Text(note)
                    }

                    ForEach(Array(tags)
                        .compactMap { MoodTagModel(from: $0) }
                        .sorted(by: { $0.name < $1.name })) { tag in
                        Image(systemName: tag.iconName)
                            .rotationEffect(.degrees(shakeAngle))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
                .onAppear {
                    Task {
                        for _ in 0..<3 {
                            withAnimation(.easeInOut(duration: 0.08)) {
                                shakeAngle = 5
                            }
                            try? await Task.sleep(nanoseconds: 80_000_000)
                            withAnimation(.easeInOut(duration: 0.08)) {
                                shakeAngle = -5
                            }
                            try? await Task.sleep(nanoseconds: 80_000_000)
                        }
                        withAnimation(.easeOut(duration: 0.1)) {
                            shakeAngle = 0
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}
