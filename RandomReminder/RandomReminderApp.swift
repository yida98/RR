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
    }
}
