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
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext(_ taskName: String? = nil) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return nil}
        
        task.name = taskName
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return task
    }
    
    func deleteData(_ task: Task) {
        viewContext.delete(task)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        var taskList: [Task] = []
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return taskList
    }
}
