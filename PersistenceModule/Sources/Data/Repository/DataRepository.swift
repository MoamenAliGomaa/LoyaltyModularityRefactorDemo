//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public final class PersistenceRepository<T: DomainEntity, U: EntityTransformer>: PersistenceRepositoryProtocol where U.DomainType == T {
    private let coreDataService: CoreDataService
    private let transformer: U
    
    public init(coreDataService: CoreDataService, transformer: U) {
        self.coreDataService = coreDataService
        self.transformer = transformer
    }
    
    public func save(_ entity: T, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.save(object: entity, transformer: transformer) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func saveAll(_ entities: [T], completion: @escaping (Result<Void, any Error>) -> Void) {
        coreDataService.save(objects: entities, transformer: transformer) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func delete(id: T.ID, completion: @escaping (Result<Void, any Error>) -> Void) {
        let predicate = NSPredicate(format: "key == %@", id as! CVarArg)
        coreDataService.delete(transformer.managedObjectType, predicate: predicate) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deleteAll(matching predicate: QueryPredicate?, completion: @escaping (Result<Void, Error>) -> Void) {
        let nsPredicate = predicate?.toNSPredicate()
        coreDataService.delete(transformer.managedObjectType, predicate: nsPredicate) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetch(
        matching predicate: QueryPredicate?,
        sortBy: [QuerySort]?,
        completion: @escaping (Result<[T], any Error>) -> Void
    ) {
        let nsPredicate = predicate?.toNSPredicate()
        var sortDescriptors: [NSSortDescriptor]?
        if let sortBy {
            let sortDescriptors = sortBy.compactMap { $0.toNSSortDescriptor() }
        }
        
        coreDataService.fetch(
            transformer.managedObjectType,
            predicate: nsPredicate,
            sortDescriptors: sortDescriptors
        ) { result in
            switch result {
            case .success(let entities):
                let fetchedEntities = entities.compactMap {[weak self] entity in
                    return self?.transformer.toDomainEntity(entity as? U.ManagedObjectType)
                }
                completion(.success(fetchedEntities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func count(
        matching predicate: QueryPredicate?,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        let nsPredicate = predicate?.toNSPredicate()
        coreDataService.noOfEntities(
            for: transformer.managedObjectType,
            predicate: nsPredicate
        ) { result in
            switch result {
            case .success(let count):
                completion(.success(count))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

