//
//  HomeScreenView.swift
//  Mooder
//
//  Created by Fietstopa on 20.06.2025.
//

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

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)]) {
                            ForEach(tags) { tag in
                                Button {
                                    viewModel.toggleTag(tag)
                                } label: {
                                    Label(tag.name, systemImage: tag.iconName)
                                        .padding(8)
                                        .background(viewModel.state.selectedTags.contains(tag) ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                        .clipShape(Capsule())
                                }
                            }
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
