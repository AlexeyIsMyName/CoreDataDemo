//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 11.03.2021.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext(_ taskName: String? = nil) -> Task? {
        let context = persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil}
        
        task.name = taskName
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return task
    }
    
    func fetchData() -> [Task] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        var taskList: [Task] = []
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return taskList
    }
}
