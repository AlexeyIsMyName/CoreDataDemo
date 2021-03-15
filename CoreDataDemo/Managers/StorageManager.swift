//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 11.03.2021.
//

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
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func saveData(_ taskName: String? = nil) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return nil}
        
        task.name = taskName
        
        saveContext()
        return task
    }
    
    func saveData(_ taskName: String, complition: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        
        task.name = taskName
        
        complition(task)
        saveContext()
    }
    
    func editData(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func deleteData(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
