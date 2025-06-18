//
//  MooderApp.swift
//  Mooder
//
//  Created by Samuel Novotný on 17.06.2025.
//

import SwiftUI
import FirebaseCore

@main
struct MooderApp: App {
    let persistenceController = PersistenceController.shared
    init() {
    }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LoginRegisterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
