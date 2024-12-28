//
//  CoreDataStack.swift
//
//
//  Created by moamen ali gomaa on 07/11/2024.
//

import CoreData
import Foundation

public final class CoreDataPersistentStore: PersistentStore {
    private let container: NSPersistentContainer
    private let contextProvider: ContextProvider
    
    public init(
        configuration: CoreDataConfigurable,
        factory: PersistentStoreFactory = DefaultPersistentStoreFactory(),
        contextProvider: ContextProvider = DefaultContextProvider()
    ) throws {
        self.container = try factory.makeContainer(with: configuration)
        self.contextProvider = contextProvider
    }
    
    public lazy var mainContext: NSManagedObjectContext = {
        guard let context = contextProvider.provideContext(from: container, type: .main) else {
            fatalError("Failed to create main context")
        }
        return context
    }()
    
    public var writingContext: NSManagedObjectContext? {
        return contextProvider.provideContext(from: container, type: .writing)
    }
    
    public var readingContext: NSManagedObjectContext? {
        return contextProvider.provideContext(from: container, type: .main)
    }
    
    public var deleteContext: NSManagedObjectContext? {
        return contextProvider.provideContext(from: container, type: .writing)
    }
}
