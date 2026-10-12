//
//  NotificationManager 2.swift
//  Mooder
//
//  Created by Samuel Novotný on 22.06.2025.
//


import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    private override init() {}
    
    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error { print("Chyba při žádosti o povolení: \(error)") }
            print(granted ? "Povolení pro notifikace získáno" : "Uživateli se nechce")
        }
    }
    
    func scheduleDailyMoodReminder(hour: Int = 20, minute: Int = 00) {
        let content       = UNMutableNotificationContent()
        content.title     = "How was your day?"
        content.body      = "Don't forget to rate your mood!🤗"
        content.sound     = .default
        content.badge     = 1
        
        var dateComponents       = DateComponents()
        dateComponents.hour       = hour
        dateComponents.minute     = minute
        
        let trigger  = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request  = UNNotificationRequest(identifier: "dailyMoodReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Nepodařilo se naplánovat notifikaci: \(error)")
            } else {
                print("Naplánováno každý den v \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
