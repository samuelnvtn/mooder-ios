//
//  MooderApp.swift
//  Mooder
//
//  Created by Samuel Novotný on 17.06.2025.
//

import SwiftUI

@main
struct MooderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
