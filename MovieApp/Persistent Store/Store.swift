//
//  Store.swift
//  MovieApp
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import CoreData

let movieStoreContainerName = "MovieApp"
let movieStore: Store = try! Store(containerName: movieStoreContainerName)


struct StoreError: Error {
    var errors: [Error] = []
}

final class Store {
    
    // MARK: - Public members
    
    init(containerName: String) throws {
        self.containerName = containerName
        
        let container = NSPersistentContainer(name: containerName)
        var storeError: StoreError?
        container.loadPersistentStores { description, error in
            // Will be called synchronously
            // May be called multiple times
            if let error = error {
                if storeError == nil {
                    storeError = StoreError()
                }
                storeError?.errors.append(error)
            }
        }
        if let storeError = storeError {
            throw storeError
        }
        
        self.persistentContainer = container
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func privateContext(block: @escaping (_ context: NSManagedObjectContext) -> ()) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            block(context)
        }
    }
    
    func privateContextAndWait(block: @escaping (_ context: NSManagedObjectContext) -> ()) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            block(context)
        }
    }
    
    
    // MARK: - Private members
    
    private var containerName: String
    private var persistentContainer: NSPersistentContainer
    
}
