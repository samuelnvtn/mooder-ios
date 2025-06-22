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
    
    init() {
           NotificationManager.shared.configure()
           NotificationManager.shared.scheduleDailyMoodReminder() // 💡 zavoláš jednou po instalaci / přihlášení
       }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
