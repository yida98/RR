//
//  DataManager.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/30/23.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private init() { }
    
    private let containerName = "ReminderModel"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("Persistent store loading error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var reminderEntity: NSEntityDescription? = {
        let managedContext = getContext()
        return NSEntityDescription.entity(forEntityName: EntityName.reminder.rawValue, in: managedContext)
    }()
    
    enum EntityName: String, CaseIterable {
        typealias RawValue = String
        
        case reminder = "Reminder"
    }
    
    func fetchAllReminders() -> [Reminder]? {
        let sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let results = fetch(entity: .reminder, sortDescriptors: sortDescriptors)
        switch results {
        case .success(let success):
            guard let reminders = success as? [Reminder] else { return nil }
            return reminders
        case .failure(_):
            return nil
        }
    }
    
    func fetchReminder(_ id: UUID) -> Reminder? {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [\Reminder.id, id as NSUUID])
        let results = fetch(entity: .reminder, predicate: predicate)
        switch results {
        case .success(let success):
            guard let reminders = success as? [Reminder], let first = reminders.first else { return nil }
            return first
        case .failure(_):
            return nil
        }
    }
    
    func saveReminder(title: String?, icon: String?, colorChoice: Int16, id: UUID?, reminderTimeFrames: [Date]?, frequency: Int16) {
        
        let context = getContext()
        guard let reminderEntity = reminderEntity else { return }
        let entity = NSManagedObject(entity: reminderEntity, insertInto: context)
        
        entity.setValue(title, forKey: "title")
        entity.setValue(icon, forKey: "icon")
        entity.setValue(id, forKey: "id")
        entity.setValue(reminderTimeFrames, forKey: "reminderTimeFrames")
        entity.setValue(frequency, forKey: "frequency")
        entity.setValue(colorChoice, forKey: "colorChoice")
        
        saveContext()
    }
    
    func saveReminder(reminder: Reminder) {
        saveReminder(title: reminder.title, icon: reminder.icon, colorChoice: reminder.colorChoice, id: reminder.id, reminderTimeFrames: reminder.reminderTimeFrames, frequency: reminder.frequency)
    }
    
    func fetch(entity: EntityName, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> Result<[NSManagedObject]?, Error> {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            return .success(results)
        } catch let error {
            return .failure(error)
        }
    }
    
    func saveContext() {
        let context = getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Handle error
                fatalError("Unable to save due to \(error)")
            }
        }
        self.objectWillChange.send()
    }
}
