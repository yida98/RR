//
//  Reminder.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import Foundation
import SwiftUI

//struct Reminder {
//    enum Frequency: Int, CaseIterable {
//        case veryInfrequent = 0, infrequent, frequent, veryFrequent, bombardment
//    }
//}

extension Reminder {
    static let colors: [Color] = [.colorSlider1, .colorSlider2, .colorSlider3, .colorSlider4, .colorSlider5, .colorSlider6, .colorSlider7, .colorSlider8]
    
    func getTimeFrameString() -> String {
        
        return "Occurs from 1:00 to 8:00, 19:30 to 23:30"
    }
}
