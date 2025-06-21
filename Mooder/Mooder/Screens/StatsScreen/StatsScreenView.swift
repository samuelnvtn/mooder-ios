//
//  StatsScreenView.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

//  StatsScreenView.swift
//  Mooder

import SwiftUI

struct StatsScreenView: View {
    @State private var viewModel: StatsScreenViewModel

    init(viewModel: StatsScreenViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("Mode", selection: $viewModel.state.chartMode) {
                    Text("Graph").tag(ChartMode.bar)
                    Text("Pie Chart").tag(ChartMode.pie)
                }
                .pickerStyle(.segmented)

                if viewModel.state.chartMode == .bar {
                    MoodBarChartView(moods: viewModel.state.moodData)
                } else {
                    MoodPieChartView(moods: viewModel.state.moodData)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Mood Overview")
                        .font(.headline)
                    Text("Average Mood: \(viewModel.state.averageMoodEmoji) \"\(viewModel.state.averageMoodLabel)\"")
                    Text("Best Week: \(viewModel.state.bestWeekText)")
                    Text("Worst Week: \(viewModel.state.worstWeekText)")
                    Text("Mood Streak: \(viewModel.state.streakText)")
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Statistics")
        .onAppear {
//            viewModel.loadData()
            viewModel.loadMockData()
        }
    }
}
