//
//  GetAllUsersUseCase.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import Combine

class GetAllUsersUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[User], Error> {
       return repository.fetchRemotUsers()
            .map { (usersDTO: [UserDTO]) in
                usersDTO.compactMap { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}
