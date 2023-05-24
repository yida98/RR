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
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["id", id as NSUUID])
        let results = fetch(entity: .reminder, predicate: predicate)
        switch results {
        case .success(let success):
            guard let reminders = success as? [Reminder], let first = reminders.first else { return nil }
            return first
        case .failure(_):
            return nil
        }
    }
    
    func saveReminder(title: String?, icon: String?, colorChoice: Int16, id: UUID?, reminderTimeFrames: [Bool]?, frequency: Int16, daysActive: [Bool]?) {
        if let id = id, let reminder = fetchReminder(id) {
            reminder.setValue(title, forKey: "title")
            reminder.setValue(icon, forKey: "icon")
            reminder.setValue(id, forKey: "id")
            reminder.setValue(reminderTimeFrames, forKey: "reminderTimeFrames")
            reminder.setValue(frequency, forKey: "frequency")
            reminder.setValue(colorChoice, forKey: "colorChoice")
            reminder.setValue(daysActive, forKey: "daysActive")
        } else {
            let context = getContext()
            guard let reminderEntity = reminderEntity else { return }
            let entity = NSManagedObject(entity: reminderEntity, insertInto: context)
            
            entity.setValue(title, forKey: "title")
            entity.setValue(icon, forKey: "icon")
            entity.setValue(id, forKey: "id")
            entity.setValue(reminderTimeFrames, forKey: "reminderTimeFrames")
            entity.setValue(frequency, forKey: "frequency")
            entity.setValue(colorChoice, forKey: "colorChoice")
            entity.setValue(daysActive, forKey: "daysActive")
        }
        
        saveContext()
    }
    
    func deleteReminder(with id: UUID) {
        guard let reminder = fetchReminder(id) else { debugPrint("unable to delete \(id)"); return }
        let context = getContext()
        context.delete(reminder)
        
        saveContext()
    }
    
    func saveReminder(reminder: Reminder) {
        saveReminder(title: reminder.title, icon: reminder.icon, colorChoice: reminder.colorChoice, id: reminder.id, reminderTimeFrames: reminder.reminderTimeFrames, frequency: reminder.frequency, daysActive: reminder.daysActive)
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
    
    func purge() {
        for entity in EntityName.allCases {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity.rawValue)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: getContext())
            } catch {
                // TODO: handle the error
                return
            }
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
