// HomeScreenView.swift
import SwiftUI

struct HomeScreenView: View {
    @State private var viewModel: HomeScreenViewModel
    @EnvironmentObject var authViewModel: AuthViewModel // 💥 přidáš tohle

    init(viewModel: HomeScreenViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How’'s your day been?")
                    .font(.title)
                    .bold()

                Text(viewModel.todayFormatted)
                    .foregroundColor(.gray)

                if viewModel.state.isMoodSavedToday {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("😁 Mood saved!")
                            .font(.headline)

                        Text("Mood: \(viewModel.moodOptions.first { $0.value == viewModel.state.selectedMood }?.label ?? "")")

                        Text("Tags:")
                            .font(.subheadline)

                        WrapTagsView(tags: viewModel.state.selectedTags)

                        Text("Note:")
                            .font(.subheadline)
                        Text(viewModel.state.note.isEmpty ? "-" : viewModel.state.note)

                        Text("✅ Come back tomorrow!")
                            .padding(.top)
                            .foregroundColor(.green)
                    }
                } else {
                    VStack {
                        ForEach(viewModel.moodOptions, id: \.value) { mood in
                            Button {
                                viewModel.selectMood(mood.value)
                            } label: {
                                HStack {
                                    Text(mood.emoji)
                                    Text(mood.label)
                                    Spacer()
                                    if viewModel.state.selectedMood == mood.value {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("Details")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    ForEach(viewModel.groupedTags, id: \.0) { (category, tags) in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(tags) { tag in
                                        Button {
                                            viewModel.toggleTag(tag)
                                        } label: {
                                            Label(tag.name, systemImage: tag.iconName)
                                                .font(.caption)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(viewModel.state.selectedTags.contains(tag) ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                                .foregroundColor(viewModel.state.selectedTags.contains(tag) ? Color.accentColor : Color.primary)
                                                .clipShape(Capsule())
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.top, 8)
                    }

                    TextField("Note", text: $viewModel.state.note)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )

                    Button("Save") {
                        viewModel.saveMood()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 16)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadToday()
        }
        .onReceive(authViewModel.$moodsDidSync) { synced in
            if synced {
                print("🔁 Sync detected, reloading today's mood")
                viewModel.loadToday()
            }
        }
    }
}
