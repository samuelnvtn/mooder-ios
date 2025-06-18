//
//  ContentView.swift
//  Mooder
//
//  Created by Samuel Novotný on 17.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        LoginRegisterView()
    }
}
