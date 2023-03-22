//
//  Reminder.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import Foundation

struct Reminder {
    var title: String
    var icon: String
    var id: UUID
    var reminderTimeFrames: [Date]
    var frequency: Frequency
    
    enum Frequency: Int, CaseIterable {
        case veryInfrequent = 0, infrequent, frequent, veryFrequent, bombardment
    }
}
