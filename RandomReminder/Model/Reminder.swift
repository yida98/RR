//
//  Reminder.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import Foundation
import SwiftUI

extension Reminder {
    static let colors: [Color] = [.colorSlider1, .colorSlider2, .colorSlider3, .colorSlider4, .colorSlider5, .colorSlider6, .colorSlider7, .colorSlider8]
    
    static func getTimeFrameString(for dates: [Date]?) -> String {
        
        return "Occurs from 1:00 to 8:00, 19:30 to 23:30"
    }
}

class DummyReminder: ObservableObject {
    @Published var id: UUID?
    @Published var title: String
    @Published var icon: String
    @Published var colorChoice: Int
    @Published var frequency: Int
    @Published var reminderTimeFrames: [Date]?
    
    init() {
        self.id = UUID()
        self.title = ""
        self.icon = ""
        self.colorChoice = 0
        self.frequency = 2
    }
    
    init(reminder: Reminder) {
        self.id = reminder.id
        self.title = reminder.title ?? ""
        self.icon = reminder.icon ?? ""
        self.colorChoice = Int(reminder.colorChoice)
        self.frequency = Int(reminder.frequency)
        self.reminderTimeFrames = reminder.reminderTimeFrames
    }
}
