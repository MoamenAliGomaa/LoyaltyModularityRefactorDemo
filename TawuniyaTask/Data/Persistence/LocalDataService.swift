//
//  LocalDataService.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import CoreData
import Combine

public protocol LocalDataService {
    func save(object: any ManagedObjectConvertible) throws
    func delete(_ model: NSManagedObject.Type, predicate: NSPredicate?) throws
    func fetch<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error> 
}
