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
    
    static func getTimeFrameString(for hours: [Bool]) -> String {
        var results = [String]()
        var hour: Hour?
        var i: Int = 0
        var j: Int = 0
        for hourIdx in 0..<hours.count {
            if hours[hourIdx] {
                j += 1
                if let hr = hour {
                    hour = hr.union(Hour(rawValue: 1 << hourIdx))
                } else {
                    hour = Hour(rawValue: 1 << hourIdx)
                }
            } else {
                if i != j {
                    results.append("\(i):00 to \(j):00")
                }
                i = j + 1
                j = i
            }
        }
        if i != j {
            results.append("\(i):00 to \(j):00")
        }
        
        var result: String = ""
        
        if hour == .morning {
            result = "all morning"
        } else if hour == .afternoon {
            result = "all afternoon"
        } else if hour == .allDay {
            result = "all day"
        } else if hour == .dayTime {
            result = "day time"
        } else if hour == .nightTime {
            result = "night time"
        } else {
            if results.isEmpty {
                return "Snoozed"
            } else {
                result = "from " + results.joined(separator: ", ")
            }
        }
        return "Occurs " + result
    }
}

struct Hour: OptionSet {
    let rawValue: Int
    
    static let twelveAM = Hour(rawValue: 1 << 0)
    static let oneAM = Hour(rawValue: 1 << 1)
    static let twoAM = Hour(rawValue: 1 << 2)
    static let threeAM = Hour(rawValue: 1 << 3)
    static let fourAM = Hour(rawValue: 1 << 4)
    static let fiveAM = Hour(rawValue: 1 << 5)
    static let sixAM = Hour(rawValue: 1 << 6)
    static let sevenAM = Hour(rawValue: 1 << 7)
    static let eightAM = Hour(rawValue: 1 << 8)
    static let nineAM = Hour(rawValue: 1 << 9)
    static let tenAM = Hour(rawValue: 1 << 10)
    static let elevenAM = Hour(rawValue: 1 << 11)
    static let twelvePM = Hour(rawValue: 1 << 12)
    static let onePM = Hour(rawValue: 1 << 13)
    static let twoPM = Hour(rawValue: 1 << 14)
    static let threePM = Hour(rawValue: 1 << 15)
    static let fourPM = Hour(rawValue: 1 << 16)
    static let fivePM = Hour(rawValue: 1 << 17)
    static let sixPM = Hour(rawValue: 1 << 18)
    static let sevenPM = Hour(rawValue: 1 << 19)
    static let eightPM = Hour(rawValue: 1 << 20)
    static let ninePM = Hour(rawValue: 1 << 21)
    static let tenPM = Hour(rawValue: 1 << 22)
    static let elevenPM = Hour(rawValue: 1 << 23)
    
    static let morning: Hour = [.twelveAM, .oneAM, .twoAM, .threeAM, .fourAM, .fiveAM, .sixAM, .sevenAM, .eightAM, .nineAM, .tenAM, .elevenAM]
    static let afternoon: Hour = [.twelvePM, .onePM, .twoPM, .threePM, .fourPM, .fivePM, .sixPM, .sevenPM, .eightPM, .ninePM, .tenPM, .elevenPM]
    static let allDay: Hour = [.morning, .afternoon]
    static let dayTime: Hour = [.sixAM, .sevenAM, .eightAM, .nineAM, .tenAM, .elevenAM, .twelvePM, .onePM, .twoPM, .threePM, .fourPM, .fivePM]
    static let nightTime: Hour = .allDay.subtracting(dayTime)
}

class DummyReminder: ObservableObject {
    @Published var id: UUID?
    @Published var title: String
    @Published var icon: String
    @Published var colorChoice: Int
    @Published var frequency: Int
    @Published var reminderTimeFrames: [Bool]
    
    init() {
        self.id = UUID()
        self.title = "Reminder"
        self.icon = ""
        self.colorChoice = Int.random(in: 0..<8)
        self.frequency = 2
        self.reminderTimeFrames = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
    }
    
    init(reminder: Reminder) {
        self.id = reminder.id
        self.title = reminder.title ?? "Reminder"
        self.icon = reminder.icon ?? ""
        self.colorChoice = Int(reminder.colorChoice)
        self.frequency = Int(reminder.frequency)
        self.reminderTimeFrames = reminder.reminderTimeFrames ?? [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
    }
}

extension DummyReminder: Equatable {
    static func == (lhs: DummyReminder, rhs: DummyReminder) -> Bool {
        lhs.id == rhs.id
    }
}
