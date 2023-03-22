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
    
    enum Frequency {
        case veryInfrequent, infrequent, frequent, veryFrequent, bombardment
    }
}
