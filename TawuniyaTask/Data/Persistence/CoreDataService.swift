//
//  CoreDataService.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import CoreData
import Combine

public class CoreDataService: LocalDataService {

    private let context: NSManagedObjectContext

    // Initialize with the context (typically injected in the repository layer)
    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Save a managed object
    public func save(object: any ManagedObjectConvertible) throws {
        object.createManageObject(context: context)
        try context.save()
    }

    public func delete(_ model: NSManagedObject.Type, predicate: NSPredicate?) throws {
        guard let entityName = model.fetchRequest().entityName, !entityName.isEmpty else {
            throw CoreDataError.entityNotFound
        }

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        try context.execute(deleteRequest)
    }

    public func fetch<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error> {

        Future<[T], Error> {[weak self] promise in
            guard let entityName = entityClass.fetchRequest().entityName, !entityName.isEmpty else {
                promise(.failure(CoreDataError.entityNotFound))
                return
            }
            
            let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors

            do {
                let fetchedObjects = try self?.context.fetch(fetchRequest)
                promise(.success(fetchedObjects ?? []))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
