//
//  MainCoreDataService.swift
//
//
//  Created by moamen ali gomaa on 07/11/2024.
//

import CoreData
import Foundation

public final class MainCoreDataService {
    private let persistentStore: PersistentStore
    private let queue: DispatchQueue
    
    public init(
        persistentStore: PersistentStore,
        queue: DispatchQueue = DispatchQueue(
            label: "com.coredata.service",
            qos: .userInitiated,
            attributes: .concurrent
        )
    ) {
        self.persistentStore = persistentStore
        self.queue = queue
    }
}

extension MainCoreDataService: CoreDataService {
    
    public func save<T: DomainEntity, U: EntityTransformer>(
        objects: [T],
        transformer: U,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) where U.DomainType == T {
        guard !objects.isEmpty else {
            completion(.success(()))
            return
        }
        
        queue.async { [weak self] in
            guard let self = self,
                  let writingContext = self.persistentStore.writingContext else {
                completion(.failure(.contextInitializationError))
                return
            }
            
            let batchSize = objects.count >= 50 ? 50 : objects.count
            let batches = objects.chunked(by: batchSize)
            var savedObjectCount = 0
            
            writingContext.performAndWait {
                for batch in batches {
                    autoreleasepool {
                        do {
                            let managedObjects = batch.compactMap { object in
                                return transformer.toStorageEntity(object, context: writingContext)
                            }
                            
                            guard managedObjects.count == batch.count else {
                                throw CoreDataError.invalidManagedObject
                            }
                            
                            try writingContext.saveAndResetIfNeeded()
                            savedObjectCount += batch.count
                            
                        } catch {
                            writingContext.rollback()
                            DispatchQueue.main.async {
                                completion(.failure(.saveFailed(error)))
                            }
                            return
                        }
                    }
                }
                
                guard savedObjectCount == objects.count else {
                    DispatchQueue.main.async {
                        completion(.failure(.saveFailed(nil)))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        }
    }
    
    public func save<T: DomainEntity, U: EntityTransformer>(
        object: T,
        transformer: U,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) where U.DomainType == T {
        queue.async { [weak self] in
            guard let self = self,
                  let writingContext = self.persistentStore.writingContext else {
                completion(.failure(.contextInitializationError))
                return
            }
            
            writingContext.performAndWait {
                do {
                    guard let _ = transformer.toStorageEntity(object, context: writingContext) else {
                        throw CoreDataError.invalidManagedObject
                    }
                    
                    try writingContext.saveIfNeeded()
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    writingContext.rollback()
                    DispatchQueue.main.async {
                        completion(.failure(.saveFailed(error)))
                    }
                }
            }
        }
    }
    
    public func fetch<T: NSManagedObject>(
        _ entityClass: NSManagedObject.Type,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        completion: @escaping (Result<[T], CoreDataError>) -> Void
    ) {
        queue.async { [weak self] in
            guard let self = self,
                    let readingContext = self.persistentStore.readingContext else {
                completion(.failure(.contextInitializationError))
                return
            }
            
             readingContext.refreshAllObjects()
            
            guard let entityName = entityClass.fetchRequest().entityName else {
                completion(.failure(.entityNotFound))
                return
            }
            
            readingContext.perform {
                do {
                    let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityClass))
                    fetchRequest.predicate = predicate
                    fetchRequest.sortDescriptors = sortDescriptors
                    fetchRequest.returnsObjectsAsFaults = false 
                    
                    let fetchedObjects = try readingContext.fetch(fetchRequest)
                    
                    DispatchQueue.main.async {
                        completion(.success(fetchedObjects))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.fetchFailed(error)))
                    }
                }
            }
        }
    }
    
    public func delete(
        _ model: NSManagedObject.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) {
        queue.async { [weak self] in
            guard let self = self,
                  let deleteContext = self.persistentStore.deleteContext else {
                completion(.failure(.contextInitializationError))
                return
            }
            
            guard let entityName = model.fetchRequest().entityName else {
                completion(.failure(.entityNotFound))
                return
            }
            
            deleteContext.performAndWait {
                do {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    request.predicate = predicate
                    
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                    deleteRequest.resultType = .resultTypeObjectIDs
                    
                    let result = try deleteContext.execute(deleteRequest) as? NSBatchDeleteResult
                    let changes: [AnyHashable: Any] = [
                        NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []
                    ]
                    
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: changes,
                        into: [deleteContext]
                    )
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.deleteFailed(error)))
                    }
                }
            }
        }
    }
    
    public func noOfEntities(
        for entity: NSManagedObject.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<Int, CoreDataError>) -> Void
    ) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(.contextInitializationError))
                return
            }
            
            guard let entityName = entity.fetchRequest().entityName else {
                completion(.failure(.entityNotFound))
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = predicate
            
            self.persistentStore.mainContext.perform {
                do {
                    let count = try self.persistentStore.mainContext.count(for: fetchRequest)
                    DispatchQueue.main.async {
                        completion(.success(count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.fetchFailed(error)))
                    }
                }
            }
        }
    }
}

extension MainCoreDataService {
    public func updateEntity<T: NSManagedObject>(
        _ entityClass: NSManagedObject.Type,
        predicate: NSPredicate?,
        updateBlock: @escaping (T) -> Void,
        completion: @escaping (Result<Void, CoreDataError>) -> Void
    ) {
        queue.async { [weak self] in
            guard let self = self,
                  let writingContext = self.persistentStore.writingContext else {
                completion(.failure(.contextInitializationError))
                return
            }
            
            guard let entityName = entityClass.fetchRequest().entityName else {
                completion(.failure(.entityNotFound))
                return
            }
            
            writingContext.performAndWait {
                do {
                    let fetchRequest = T.fetchRequest()
                    fetchRequest.predicate = predicate
                    
                    let objects = try writingContext.fetch(fetchRequest) as? [T] ?? []
                    
                    objects.forEach { object in
                        updateBlock(object)
                    }
                    
                    try writingContext.saveIfNeeded()
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    writingContext.rollback()
                    DispatchQueue.main.async {
                        completion(.failure(.saveFailed(error)))
                    }
                }
            }
        }
    }
}
