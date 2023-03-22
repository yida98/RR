//
//  RemindersViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import Foundation

class RemindersViewModel: ObservableObject {
    var reminders: [Reminder]
    
    init(reminders: [Reminder]) {
        self.reminders = reminders
    }
}
