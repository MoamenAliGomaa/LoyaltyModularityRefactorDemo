//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public protocol PersistentStoreFactory {
    func makeContainer(with configuration: CoreDataConfigurable) throws -> NSPersistentContainer
}
