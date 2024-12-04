//
//  GetAllUsersUseCase.swift
//  TawuniyaTask
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
        let remoteUsers: AnyPublisher<[User], Error> = repository.fetchRemotUsers()
            .map { (usersDTO: [UserDTO]) in
                usersDTO.compactMap { $0.toDomain() }
            }
            .eraseToAnyPublisher()
        
        let likedUsers: AnyPublisher<[User], Error> = repository.fetchLikedUsers()
            .map { (usersDTO: [UserMO]) in
                usersDTO.compactMap { $0.toDomain() }
            }
            .catch { _ in Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return remoteUsers
            .combineLatest(likedUsers)
            .map { (apiUsers, likedUsers) in
                apiUsers.map { apiUser in
                    apiUser.isLiked = likedUsers.contains { likedUser in
                        apiUser.id == likedUser.id
                    }
                    return apiUser
                }
            }
            .eraseToAnyPublisher()
    }
}
