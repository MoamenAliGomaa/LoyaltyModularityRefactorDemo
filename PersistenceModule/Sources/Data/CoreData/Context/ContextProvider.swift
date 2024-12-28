//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public protocol ContextProvider {
    func provideContext(from container: NSPersistentContainer, type: ContextType) -> NSManagedObjectContext?
}
