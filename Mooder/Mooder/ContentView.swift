//
//  ContentView.swift
//  Mooder
//
//  Created by Samuel Novotný on 17.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSplash = true
    @State private var authSessionID = UUID()
    

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .animation(.easeOut(duration: 1.5), value: showSplash)
            } else {
                if authViewModel.isLoggedIn && authViewModel.moodsDidSync {
                    // 💥 vytvoř nový CalendarViewModel až PO synchronizaci
                    @StateObject var calendarViewModel = CalendarScreenViewModel(context: CoreDataManager().context)

                    TabView {
                        HomeScreenView(viewModel: HomeScreenViewModel(calendarViewModel: calendarViewModel))
                            .environmentObject(authViewModel)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }

                        CalendarScreenView(context: calendarViewModel.context)
                            .tabItem {
                                Label("Calendar", systemImage: "calendar")
                            }

                        StatsScreenView(viewModel: StatsScreenViewModel())
                            .tabItem {
                                Label("Stats", systemImage: "cellularbars")
                            }

                        SettingsScreenView(viewModel: SettingsViewModel())
                            .environmentObject(authViewModel)
                            .tabItem {
                                Label("Settings", systemImage: "gearshape")
                            }
                    }
                } else if authViewModel.isLoggedIn && !authViewModel.moodsDidSync {
                    ProgressView("Loading your data…")
                } else {
                    LoginRegisterView(viewModel: authViewModel)
                        .onAppear { print("🧾 Showing LoginRegisterView") }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showSplash = false
            }
        }
        .onChange(of: authViewModel.isLoggedIn) { newValue in
            print("🔄 authViewModel.isLoggedIn changed: \(newValue)")
        }
        .id(authViewModel.didLoginSession)
    }
}
