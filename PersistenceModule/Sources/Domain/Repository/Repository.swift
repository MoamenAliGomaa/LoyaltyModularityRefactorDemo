//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public protocol PersistenceRepositoryProtocol<T> {
    associatedtype T: DomainEntity
    
    func save(_ entity: T, completion: @escaping (Result<Void, Error>) -> Void)
    func saveAll(_ entities: [T], completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: T.ID, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAll(
        matching predicate: QueryPredicate?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func fetch(
        matching predicate: QueryPredicate?,
        sortBy: [QuerySort]?,
        completion: @escaping (Result<[T], Error>) -> Void
    )
    func count(
        matching predicate: QueryPredicate?,
        completion: @escaping (Result<Int, Error>) -> Void
    )
}
