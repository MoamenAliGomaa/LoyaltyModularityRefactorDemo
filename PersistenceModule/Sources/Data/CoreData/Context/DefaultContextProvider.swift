//
//  File 2.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public final class DefaultContextProvider: ContextProvider {
    public init() {}
    
    public func provideContext(
        from container: NSPersistentContainer,
        type: ContextType
    ) -> NSManagedObjectContext? {
        switch type {
        case .main:
            let context = container.viewContext
            return context
            
        case .writing:
            return BackgroundManagedObjectContext(container) { context in
                context.automaticallyMergesChangesFromParent = type.configuration.mergesChanges
                context.name = type.configuration.name
                context.transactionAuthor = type.configuration.author
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                context.shouldDeleteInaccessibleFaults = true  
                context.retainsRegisteredObjects = false
            }.context
        }
    }
}
