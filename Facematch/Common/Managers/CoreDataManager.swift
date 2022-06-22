//
//  CoreDataManager.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

import CoreData
import CloudKit

protocol CoreDataManaging {
    func saveContext()

    var persistentContainer: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
}

class CoreDataManager: CoreDataManaging {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Facematch")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No descriptions present")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data persistence container: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Failed to save Core Data context: \(error)")
            }
        }
    }
}
