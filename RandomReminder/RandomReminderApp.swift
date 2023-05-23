//
//  RandomReminderApp.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/20/23.
//

import SwiftUI

@main
struct RandomReminderApp: App {
    @StateObject var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
    }
}

class AppData: ObservableObject {
    @UserDefault(.snoozedReminders)
    private var snoozedReminders: [UUID] = [UUID]() {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    @Published var authorization: Bool = true
    
    init() {
        requestNotificationAuthorizationCheck()
        scheduleRandomReminders()
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.scheduleRandomReminders()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.requestNotificationAuthorizationCheck()
            }
        }
    }
    
    private func requestNotificationAuthorizationCheck() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings]) { granted, error in
            
            if let error = error {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
            DispatchQueue.main.async {
                self.authorization = granted
            }
        }
    }
    
    func scheduleRandomReminders() {
        // Remove all existing reminders
        NotificationManager.shared.removeAllNotifications()
        
        // Fetch all reminders
        if let reminders = DataManager.shared.fetchAllReminders() {
            let filteredReminders = reminders.filter({ if let id = $0.id { return !snoozedReminders.contains(id) } else { return false } })
            // Reschedule every reminder
            NotificationManager.shared.scheduleNotifications(filteredReminders)
        }
    }
    
    func snooze(_ id: UUID) {
        if snoozedReminders.contains(id) {
            snoozedReminders.removeAll(where: { $0 == id })
        } else {
            snoozedReminders.append(id)
        }
        
        scheduleRandomReminders()
    }
    
    func isSnoozed(_ id: UUID) -> Bool {
        snoozedReminders.contains(id)
    }
}

extension UserDefault.Key {
    static var snoozedReminders: UserDefault.Key { UserDefault.Key("snoozedReminders") }
}

@propertyWrapper
class UserDefault<Value: Codable>: ObservableObject {
    private let key: Key
    private let defaultValue: Value
    private var container: UserDefaults = .standard
    
    init(wrappedValue defaultValue: Value, _ key: Key) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get { fetch() }
        set { save(newValue) }
    }
    
    private func fetch() -> Value {
        let object = container.object(forKey: key.value)
        if let objectValue = object as? Value {
            return objectValue
        } else if let objectData = object as? Data, let decodedData = try? JSONDecoder().decode(Value.self, from: objectData) {
            return decodedData
        }
        return defaultValue
    }
    
    private func save(_ newValue: Value) {
        self.objectWillChange.send()
        if newValue is PropertyListValue {
            container.setValue(newValue, forKey: key.value)
        } else if let jsonData = try? JSONEncoder().encode(newValue) {
            container.setValue(jsonData, forKey: key.value)
        }
    }
    
    struct Key {
        let value: String
        init(_ value: String) {
            self.value = value
        }
    }
}

protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

// Every element must be a property-list type
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
