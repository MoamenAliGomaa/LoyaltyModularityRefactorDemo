//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public protocol EntityTransformer {
    associatedtype DomainType: DomainEntity
    associatedtype ManagedObjectType: NSManagedObject
    
    var managedObjectType: NSManagedObject.Type { get }
    
    func toStorageEntity(_ entity: DomainType?, context: NSManagedObjectContext) -> ManagedObjectType?
    func toDomainEntity(_ object: ManagedObjectType?) -> DomainType?
}
