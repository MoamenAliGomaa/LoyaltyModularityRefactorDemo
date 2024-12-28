//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public final class DefaultPersistentStoreFactory: PersistentStoreFactory {
    public init() {}
    
    public func makeContainer(with configuration: CoreDataConfigurable) throws -> NSPersistentContainer {
        guard let bundle = Bundle(identifier: configuration.bundleIdentifier) else {
            throw CoreDataError.bundleNotFound
        }
        
        guard let modelURL = bundle.url(forResource: configuration.modelName, withExtension: "momd") else {
            throw CoreDataError.modelNotFound
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoreDataError.invalidModel
        }
        
        let container = NSPersistentContainer(
            name: configuration.modelName,
            managedObjectModel: managedObjectModel
        )
        
        if configuration.inMemory {
            guard let description = container.persistentStoreDescriptions.first else {
                throw CoreDataError.storeDescriptionNotFound
            }
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        
        if let error = loadError {
            throw error
        }
        
//        if let storeURL = container.persistentStoreCoordinator.persistentStores.first?.url {
//            print("CoreData store location: \(storeURL)")
//        }
        
        return container
    }
}
