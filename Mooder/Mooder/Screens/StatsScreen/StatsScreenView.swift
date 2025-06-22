//
//  StatsScreenView.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import SwiftUI

struct StatsScreenView: View {
    @State private var viewModel: StatsScreenViewModel

    init(viewModel: StatsScreenViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Statistics")
                    .font(.title)
                    .bold()                
                 
                // Přepínač grafů
                Picker("Mode", selection: $viewModel.state.chartMode) {
                    Text("Graph").tag(ChartMode.bar)
                    Text("Pie Chart").tag(ChartMode.pie)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Zobrazení grafu
                if viewModel.state.chartMode == .bar {
                    HStack {
                        Button("← Previous") {
                            viewModel.previousWeek()
                        }
                        .disabled(!viewModel.canGoToPreviousWeek)
                        .opacity(viewModel.canGoToPreviousWeek ? 1 : 0.3)

                        Spacer()

                        Text(viewModel.formattedCurrentWeekRange())
                            .font(.subheadline)
                            .monospacedDigit()

                        Spacer()

                        Button("Next →") {
                            viewModel.nextWeek()
                        }
                        .disabled(!viewModel.canGoToNextWeek)
                        .opacity(viewModel.canGoToNextWeek ? 1 : 0.3)
                    }
                    .padding(.horizontal)

                    MoodBarChartView(
                        moods: viewModel.state.moodData,
                        weekDates: viewModel.currentWeekDates()
                    )

                    // Týdenní navigace – jen pro bar chart
                   

                } else {
                    // Pie chart pro celou historii
                    MoodPieChartView(moods: viewModel.allMoods)
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.trailing)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                //GPTTipComponent(moodEntries: viewModel.allMoods)

            }
            .padding()
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
