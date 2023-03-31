//
//  ContentViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var reminders: [Reminder]
    @Published var reminderUnderConstruction: DummyReminder
    
    init() {
        self.reminders = ContentViewModel.fetchReminders()
        self.reminderUnderConstruction = DummyReminder()
    }
    
    static func fetchReminders() -> [Reminder] {
        DataManager.shared.fetchAllReminders() ?? []
    }
    
    func getEditorViewModel() -> EditorViewModel {
        return EditorViewModel()
    }
}

class DummyReminder: ObservableObject {
    @Published var id: UUID?
    @Published var title: String
    @Published var icon: String
    @Published var colorChoice: Int16
    @Published var frequency: Int16
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
        self.colorChoice = reminder.colorChoice
        self.frequency = reminder.frequency
        self.reminderTimeFrames = reminder.reminderTimeFrames
    }
}
