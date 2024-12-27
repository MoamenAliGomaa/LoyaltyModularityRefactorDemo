//
//  CoreDataStorage.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 26/12/2024.
//

import Foundation
import PersistenceModule


public final class CoreDataCacheRepository: CacheRepositoryProtocol {
    private let repository: any PersistenceRepositoryProtocol<CashedDomainResponse>
    private let expirationDuration: TimeInterval
    
    init<R: PersistenceRepositoryProtocol>(repository: R, expirationDuration: TimeInterval = 86400) where R.T == CashedDomainResponse {
        self.repository = repository
        self.expirationDuration = expirationDuration
    }
    
    func save(_ object: CashedDomainResponse, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.save(object) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieve(forKey key: String, completion: @escaping (Result<CashedDomainResponse?, any Error>) -> Void) {
        removeExpired {[weak self] result in
            guard let self else { return }
            let predicate = QueryPredicate(
                field: "",
                operation: .and,
                value: [
                    QueryPredicate(field: "key", operation: .equals, value: key),
                    QueryPredicate(field: "timestamp", operation: .greaterThan, value: Date().addingTimeInterval(-expirationDuration))
                ]
            )
            repository.fetch(matching: predicate, sortBy: nil) { result in
                switch result {
                case .success(let objects):
                    completion(.success(objects.first))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func remove(forKey key: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let predicate = QueryPredicate(field: "key", operation: .equals, value: key)
        
        repository.deleteAll(matching: predicate){ result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func removeExpired(
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let predicate = QueryPredicate(
            field: "timestamp",
            operation: .lessThan,
            value: Date().addingTimeInterval(-expirationDuration)
        )
        
        repository.deleteAll(matching: predicate) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
