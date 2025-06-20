// HomeScreenView.swift

import SwiftUI

struct HomeScreenView: View {
    @State private var viewModel: HomeScreenViewModel

    init(viewModel: HomeScreenViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How’s your day been?")
                    .font(.title)
                    .bold()

                Text(viewModel.todayFormatted)
                    .foregroundColor(.gray)

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

                        // MARK: - Změny zde pro horizontální scrollování a dynamickou šířku tagů
                        ScrollView(.horizontal, showsIndicators: false) { // Horizontalní scroll
                            HStack(spacing: 8) { // Mezera mezi tagy
                                ForEach(tags) { tag in
                                    Button {
                                        viewModel.toggleTag(tag)
                                    } label: {
                                        Label(tag.name, systemImage: tag.iconName)
                                            .font(.caption) // Zmenšený font pro lepší kompaktnost
                                            .padding(.horizontal, 10) // Horizontální padding
                                            .padding(.vertical, 6)   // Vertikální padding
                                            .background(viewModel.state.selectedTags.contains(tag) ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                            .foregroundColor(viewModel.state.selectedTags.contains(tag) ? Color.accentColor : Color.primary) // Barva textu
                                            .clipShape(Capsule()) // Zaoblený tvar
                                            .lineLimit(1) // Zabrání zalamování textu
                                    }
                                }
                            }
                            .padding(.vertical, 4) // Trochu vertikálního paddingu pro ScrollView
                        }
                    }
                    .padding(.top, 8)
                }

                Button("Save") {
                    viewModel.saveMood()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 16)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadToday()
        }
    }
}
