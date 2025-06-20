//
//  CalendarScreenView.swift
//  Mooder
//
//  Created by Samuel Novotný on 20.06.2025.
//

import SwiftUI
import SwiftUICalendar

struct CalendarScreenView: View {
    let viewModel: CalendarScreenViewModel
    
    @ObservedObject var controller: CalendarController = CalendarController()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood timeline")
                .font(.title)
                .bold()
                .padding(.top, 16)
            
            
            GeometryReader { reader in
                
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        Button("Prev") {
                            controller.scrollTo(controller.yearMonth.addMonth(value: -1), isAnimate: true)
                        }
                        .padding(8)
                        Spacer()
                        Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                            .font(.title)
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        Spacer()
                        Button("Next") {
                            controller.scrollTo(controller.yearMonth.addMonth(value: 1), isAnimate: true)
                        }
                        .padding(8)
                    }
                    CalendarView(controller, header: { week in
                        GeometryReader { geometry in
                            Text(week.shortString)
                                .font(.subheadline)
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        }
                    }, component: { date in
                        GeometryReader { geometry in
                            Text("\(date.day)")
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .font(.system(size: 10, weight: .light, design: .default))
                                .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                        }
                    })
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
