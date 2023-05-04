//
//  RandomReminderApp.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/20/23.
//

import SwiftUI

@main
struct RandomReminderApp: App {
    @StateObject var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppData: ObservableObject {
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
        }
    }
    
    func scheduleRandomReminders() {
        // Remove all existing reminders
        
        
        // Fetch all reminders
        
        // Schedule every reminder
    }
}
