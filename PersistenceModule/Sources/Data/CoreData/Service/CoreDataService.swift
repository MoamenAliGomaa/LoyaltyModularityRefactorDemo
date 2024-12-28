//
//  CoreDataService.swift
//
//
//  Created by moamen ali gomaa on 05/11/2024.
//

import CoreData
import Foundation

public protocol CoreDataService {
    func save<T: DomainEntity, U: EntityTransformer>(
        objects: [T],
        transformer: U,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) where U.DomainType == T
    
    func save<T: DomainEntity, U: EntityTransformer>(
        object: T,
        transformer: U,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) where U.DomainType == T
    
    func delete(
        _ model: NSManagedObject.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    )
    
    func noOfEntities(
        for entity: NSManagedObject.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<Int, CoreDataError>) -> Void
    )
    
    func fetch(
          _ entityClass: NSManagedObject.Type,
          predicate: NSPredicate?,
          sortDescriptors: [NSSortDescriptor]?,
          completion: @escaping (Result<[NSManagedObject], CoreDataError>) -> Void
      )
    
    func updateEntity<T: NSManagedObject>(
        _ entityClass: NSManagedObject.Type,
        predicate: NSPredicate?,
        updateBlock: @escaping (T) -> Void,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    )
}
