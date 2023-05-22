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
    
    init() {
        self.reminders = ContentViewModel.fetchReminders()
        self.reminderUnderConstruction = DummyReminder()
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
            editorViewModel = EditorViewModel(reminder: _reminderUnderConstruction)
        }
        return editorViewModel!
    }
    
    func saveReminderUnderConstruction() {
        DataManager.shared.saveReminder(title: reminderUnderConstruction.title,
                                        icon: reminderUnderConstruction.icon,
                                        colorChoice: Int16(reminderUnderConstruction.colorChoice),
                                        id: reminderUnderConstruction.id,
                                        reminderTimeFrames: reminderUnderConstruction.reminderTimeFrames,
                                        frequency: Int16(reminderUnderConstruction.frequency),
                                        daysActive: reminderUnderConstruction.daysActive)
        
        reminders = ContentViewModel.fetchReminders()
    }
    
    func setupEditor() {
        editorViewModel = nil
    }
    
    func makeNewReminder() {
        reminderUnderConstruction = DummyReminder()
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
    
    func setDummyReminder(_ reminder: Reminder) {
        setupEditor()
        reminderUnderConstruction = DummyReminder(reminder: reminder)
    }
}
