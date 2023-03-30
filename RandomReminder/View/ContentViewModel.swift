//
//  ContentViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var reminders: [Reminder]
    
    init() {
        self.reminders = ContentViewModel.fetchReminders()
    }
    
    static func fetchReminders() -> [Reminder] {
        DataManager.shared.fetchAllReminders() ?? []
    }
    
    func getEditorViewModel() -> EditorViewModel {
        return EditorViewModel()
    }
}
