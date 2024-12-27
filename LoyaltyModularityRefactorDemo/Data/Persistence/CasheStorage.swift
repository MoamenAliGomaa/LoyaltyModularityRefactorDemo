//
//  CasheStorage.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 26/12/2024.
//

import Foundation
import PersistenceModule

// MARK: - Cache Repository Protocol
protocol CacheRepositoryProtocol {
    func save(
        _ object: CashedDomainResponse,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func retrieve(
        forKey key: String,
        completion: @escaping (Result<CashedDomainResponse?, Error>) -> Void
    )
    func remove(
        forKey key: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func removeExpired(
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

