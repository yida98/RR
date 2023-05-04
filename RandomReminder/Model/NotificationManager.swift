//
//  NotificationManager.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/21/23.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func makeNotification(from reminder: Reminder, at dateComponents: DateComponents) {
        guard let uuid = reminder.id else { return }
        
        // Content
        let content = UNMutableNotificationContent()
        
        content.title = "This is the title"
        content.body = "This is the body"
        
        // Trigger
        let triggerDates = reminder.getExecutionTimes()
        
        var requests = [UNNotificationRequest]()
        
        for triggerDate in triggerDates {
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: triggerDate, repeats: true)
            
            let uuidString = uuid.uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)
            
            requests.append(request)
        }
        
        scheduleNotificationRequests(requests)
    }
    
    private func scheduleNotificationRequests(_ requests: [UNNotificationRequest]) {
        for request in requests {
            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
               } else {
                   
               }
            }
        }
    }
    
    func scheduleTestNotifications() {
        let content = UNMutableNotificationContent()
        
        content.title = "This is a TEST"
        content.body = "TEST BODY"
        
        let currentDateComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: Date().addingTimeInterval(10))
        
        debugPrint(currentDateComponent)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: currentDateComponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TEST", content: content, trigger: trigger)
        
        scheduleNotificationRequests([request])
    }
    
    func removeTestNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["TEST"])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ["TEST"])
    }
    
    private func removeScheduledNotification(with id: UUID) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }
    
    private func removeAllNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
