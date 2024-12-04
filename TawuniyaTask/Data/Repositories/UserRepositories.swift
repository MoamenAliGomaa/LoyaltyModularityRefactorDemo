//
//  UserRepositories.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

class UserRepository: UserRepositoryProtocol {
    private let networkLayer: NetworkLayer
    private let localDataService: LocalDataService
    
    init(networkLayer: NetworkLayer, localDataService: LocalDataService) {
        self.networkLayer = networkLayer
        self.localDataService = localDataService
    }
    
    func fetchRemotUsers() -> AnyPublisher<[UserDTO], Error> {
        return networkLayer.request(builder: APIRouter.getUsers).eraseToAnyPublisher()
    }
    
    func fetchLikedUsers() -> AnyPublisher<[UserMO], Error> {
        return localDataService.fetch(UserMO.self, predicate: nil, sortDescriptors: nil).eraseToAnyPublisher()
    }
    
    func save(user: User) throws {
        try localDataService.save(object: user)
    }
    
    func delete(user: User) throws {
        guard let id = user.id else { return }
        try localDataService.delete(UserMO.self, predicate: NSPredicate(format: "userId == %d", id))
    }
}

