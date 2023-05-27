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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    static func requestNotificationPermission(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completion)
    }
    
    func scheduleNotifications(_ reminders: [Reminder]) {
        for reminder in reminders {
            makeNotification(from: reminder)
        }
    }
    
    private func makeNotification(from reminder: Reminder) {
        guard let uuid = reminder.id else { return }
        
        // Content
        let content = UNMutableNotificationContent()
        
        content.title = reminder.icon ?? "🔔"
        content.body =  reminder.title ?? "Random reminder"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alert.aif"))
        
        // Trigger
        let triggerDates = reminder.getExecutionTimes()
        
        var requests = [UNNotificationRequest]()
        
        for triggerDateIndex in 0..<triggerDates.count {
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: triggerDates[triggerDateIndex], repeats: true)
            
            let uuidString = uuid.uuidString + String(triggerDateIndex)
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)
            
            requests.append(request)
        }
        
        scheduleNotificationRequests(requests)
    }
    
    private func scheduleNotificationRequests(_ requests: [UNNotificationRequest]) {
        debugPrint("schedule")
        for request in requests {
            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
               } else {
//                   debugPrint("scheduled request \(request)")
               }
            }
        }
    }
    
    func removeScheduledNotification(with id: UUID) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { requests in
            let filteredRequestsIdentifiers = requests.filter { $0.identifier.hasPrefix(id.uuidString) }.map { $0.identifier }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: filteredRequestsIdentifiers)
            notificationCenter.removeDeliveredNotifications(withIdentifiers: filteredRequestsIdentifiers)
        }
    }
    
    func removeAllNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

// MARK: - Test
extension NotificationManager {
    func scheduleTestNotifications() {
        let content = UNMutableNotificationContent()
        
        content.title = "This is a TEST"
        content.body = "TEST BODY"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alert.aif"))
        
        let currentDateComponent = Calendar.current.dateComponents([.hour, .minute, .second], from: Date().addingTimeInterval(10))
                
        let trigger = UNCalendarNotificationTrigger(dateMatching: currentDateComponent, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TEST", content: content, trigger: trigger)
        
        scheduleNotificationRequests([request])
    }
    
    func removeTestNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["TEST"])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ["TEST"])
    }
}
