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

    var body: some View {
        ZStack{
            if showSplash{
                SplashView()
                    .transition(.opacity)
                    .animation(.easeOut(duration: 1.5), value: showSplash)
            } else {
                if authViewModel.isLoggedIn {
                    HomeScreenView(viewModel: HomeScreenViewModel())
                        .onAppear { print("✅ Showing HomeScreenView") }
                } else {
                    LoginRegisterView(viewModel: authViewModel)
                        .onAppear { print("🧾 Showing LoginRegisterView") }
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showSplash = false
            }
        }
        .onChange(of: authViewModel.isLoggedIn) { newValue in
            print("🔄 authViewModel.isLoggedIn changed: \(newValue)")
        }
    }
}
