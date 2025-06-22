//
//  CalendarScreenView.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import SwiftUI
import SwiftUICalendar
import CoreData

struct CalendarScreenView: View {
    @StateObject var viewModel: CalendarScreenViewModel
    @StateObject var controller = CalendarController()
    
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: CalendarScreenViewModel(context: context))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood timeline")
                .font(.title)
                .bold()
                .padding(.top)
            
            
            GeometryReader { reader in
                
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        Button("Prev") {
                            controller.scrollTo(controller.yearMonth.addMonth(value: -1), isAnimate: true)
                        }
                        .padding(8)
                        Spacer()
                        Button(action: {
                            controller.scrollTo(YearMonth.current, isAnimate: true)
                        }) {
                            Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                                .font(.title)
                                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                        Spacer()
                        Button("Next") {
                            controller.scrollTo(controller.yearMonth.addMonth(value: 1), isAnimate: true)
                        }
                        .padding(8)
                    }
                    CalendarView(controller, startWithMonday: true, header: { week in
                        GeometryReader { geometry in
                            Text(week.shortString)
                                .font(.subheadline)
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        }
                    }, component: { date in
                        GeometryReader { geometry in
                            let calendar = Calendar.current
                            let dateComponents = DateComponents(year: date.year, month: date.month, day: date.day)
                            let startOfDay = calendar.startOfDay(for: calendar.date(from: dateComponents)!)
                            let moodValue = viewModel.state.moodDates[startOfDay]?.mood ?? 0
                            let moodColor = MoodLevel(rawValue: moodValue)?.color.opacity(1) ?? Color.clear
                            let isSelected = viewModel.state.selectedEntry?.date == startOfDay
                            
                            Button {
                                viewModel.select(date: startOfDay)
                            } label: {
                                Text("\(date.day)")
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(moodValue > 0 ? .white : .gray)
                                    .background(moodColor)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(isSelected && moodValue > 0 ? Color.blue : Color.clear, lineWidth: 2)
                                            .animation(.easeOut(duration: 0.3), value: isSelected)
                                    )
                            }
                        }
                    })
                }.onAppear {
                    viewModel.reloadData()   // ⬅️ vždy si znova načti položky
                }
            }
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: Binding(
            get: { viewModel.state.selectedEntry != nil },
            set: { if !$0 { viewModel.state.selectedEntry = nil } }
        )) {
            if let entry = viewModel.state.selectedEntry {
                MoodDetailSheet(entry: entry)
                    .presentationDetents([.height(200)])
            }
        }
    }
    
}
