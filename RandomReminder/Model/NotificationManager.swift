//
//  NotificationManager.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/21/23.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static let shared = NotificationManager()
    
    func makeNotification(from reminder: Reminder, at dateComponents: DateComponents) {
        guard let uuid = reminder.id else { return }
        
        // Content
        let content = UNMutableNotificationContent()
        
        content.title = "This is the title"
        content.body = "This is the body"
        
        // Trigger
        var dateComponents = dateComponents
        
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        let uuidString = uuid.uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    func makeDateComponents(for reminder: Reminder) -> [DateComponents] {
        var dateComponents = DateComponents()
        
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 3  // Tuesday
        dateComponents.hour = 14    // 14:00 hours
        dateComponents.minute = 12  // 14:12
        
        return [dateComponents]
    }
    
    private func scheduleNotification(_ notification: UNMutableNotificationContent) {
        
    }
    
    private func removeScheduledNotification(with id: UUID) {
        
    }
}
