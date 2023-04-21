//
//  ContentViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation
import UIKit
import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var reminders: [Reminder]
    @Published var reminderUnderConstruction: DummyReminder
    var dummyReminderBinding: Binding<DummyReminder>
    
    init() {
        self.reminders = ContentViewModel.fetchReminders()
        self.reminderUnderConstruction = DummyReminder()
        self.dummyReminderBinding = .constant(DummyReminder())
        
        self.dummyReminderBinding = .init(get: { [weak self] in
            self?.reminderUnderConstruction ?? DummyReminder()
        }, set: { [weak self] reminder in
            self?.reminderUnderConstruction = reminder
        })
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            guard let strongSelf = self else { return }
            for reminder in strongSelf.reminders {
                DataManager.shared.saveReminder(reminder: reminder)
            }
        }
    }
    
    static func fetchReminders() -> [Reminder] {
        DataManager.shared.fetchAllReminders() ?? []
    }
    
    var editorViewModel: EditorViewModel?
    func getEditorViewModel() -> EditorViewModel {
        if editorViewModel == nil {
            editorViewModel = EditorViewModel(reminder: reminderUnderConstruction)
        }
        return editorViewModel!
    }
    
    func saveReminderUnderConstruction() {
        DataManager.shared.saveReminder(title: reminderUnderConstruction.title,
                                        icon: reminderUnderConstruction.icon,
                                        colorChoice: Int16(reminderUnderConstruction.colorChoice),
                                        id: reminderUnderConstruction.id,
                                        reminderTimeFrames: reminderUnderConstruction.reminderTimeFrames,
                                        frequency: Int16(reminderUnderConstruction.frequency))
        
        reminders = ContentViewModel.fetchReminders()
    }
    
    func makeNewReminder() {
        self.reminderUnderConstruction = DummyReminder()
        self.editorViewModel = nil
    }
    
    func updateReminder(_ id: UUID, reminder: DummyReminder) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].id = reminder.id
            reminders[index].title = reminder.title
            reminders[index].icon = reminder.icon
            reminders[index].colorChoice = Int16(reminder.colorChoice)
            reminders[index].frequency = Int16(reminder.frequency)
            reminders[index].reminderTimeFrames = reminder.reminderTimeFrames
        }
    }
}
