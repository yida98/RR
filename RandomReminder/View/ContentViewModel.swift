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
                                        frequency: Int16(reminderUnderConstruction.frequency))
    }
}
