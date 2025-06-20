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
    @State private var shownTagName: String? = nil
    @State private var labelPosition: CGPoint? = nil
    
    private var moodColor: Color {
        MoodLevel(rawValue: entry.mood)?.color ?? .secondary
    }

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
                ZStack(alignment: .topLeading) {
                    HStack(spacing: 8) {
                        if !note.isEmpty {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(moodColor)
                                    .frame(width: 8, height: 8)
                                Text(note)
                            }
                        }

                        ForEach(Array(tags)
                            .compactMap { MoodTagModel(from: $0) }
                            .sorted(by: { $0.name < $1.name })) { tag in
                            GeometryReader { geo in
                                Button(action: {
                                    shownTagName = tag.name
                                    labelPosition = geo.frame(in: .named("capsuleArea")).origin
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            shownTagName = nil
                                        }
                                    }
                                }) {
                                    Image(systemName: tag.iconName)
                                        .rotationEffect(.degrees(shakeAngle))
                                }
                                .frame(width: 24, height: 24)
                            }
                            .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                    .coordinateSpace(name: "capsuleArea")

                    if let tagName = shownTagName, let position = labelPosition {
                        Text(tagName)
                            .font(.caption2)
                            .padding(6)
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .position(x: position.x + 12, y: 60)
                            .transition(.opacity)
                            .animation(.easeInOut, value: shownTagName)
                    }
                }
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
