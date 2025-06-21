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
                // Přepínač grafů
                Picker("Mode", selection: $viewModel.state.chartMode) {
                    Text("Graph").tag(ChartMode.bar)
                    Text("Pie Chart").tag(ChartMode.pie)
                }
                .pickerStyle(.segmented)

                // Týdenní navigace
                HStack {
                    Button("← Previous") {
                        viewModel.previousWeek()
                    }
                    Spacer()
                        Text(viewModel.formattedCurrentWeekRange())
                            .font(.subheadline)
                            .monospacedDigit()
                        Spacer()
                    Button("Next →") {
                        viewModel.nextWeek()
                    }
                }
                .padding(.horizontal)

                // Zobrazení grafu
                if viewModel.state.chartMode == .bar {
                    MoodBarChartView(
                        moods: viewModel.state.moodData,
                        weekDates: viewModel.currentWeekDates()
                    )
                } else {
                    MoodPieChartView(moods: viewModel.state.moodData)
                }

                // Přehled nálad
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
            viewModel.loadData()
        }
    }
}
