//
//  UserRepositories.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine
import PersistenceModule
import CoreData

class UserRepository: UserRepositoryProtocol {
    typealias T = DomainEntity
    private let proxy: NetworkServiceProtocol
    private let persistenceRepository: any PersistenceRepositoryProtocol<CashedDomainResponse>
    
    init(proxy: NetworkServiceProtocol, persistenceRepository: any PersistenceRepositoryProtocol<CashedDomainResponse>) {
        self.proxy = proxy
        self.persistenceRepository = persistenceRepository
    }
    
    func fetchRemotUsers() -> AnyPublisher<[UserDTO], Error> {
        return Future {[weak self] promise in
            guard let self else { return }
            proxy.request(APIRouter.getUsers, responseType: Optional<[UserDTO]>.self) { result in
                switch result {
                case .success(let users):
                    if let users = users {
                        promise(.success(users))
                    } else {
                        promise(.success([]))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

