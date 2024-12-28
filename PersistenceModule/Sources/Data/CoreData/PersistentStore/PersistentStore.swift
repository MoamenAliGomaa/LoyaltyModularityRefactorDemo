//
//  PersistentStore.swift
//  
//
//  Created by moamen ali gomaa on 16/11/2024.
//

import CoreData
import Foundation

public protocol PersistentStore {
    var mainContext: NSManagedObjectContext { get }
    var writingContext: NSManagedObjectContext? { get }
    var readingContext: NSManagedObjectContext? { get }
    var deleteContext: NSManagedObjectContext? { get }
}
