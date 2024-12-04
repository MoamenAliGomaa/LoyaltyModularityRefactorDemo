//
//  UserRepositoryProtocol.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func fetchRemotUsers() -> AnyPublisher<[UserDTO], Error>
    func fetchLikedUsers() -> AnyPublisher<[UserMO], Error>
    func save(user: User) throws
    func delete(user: User) throws
}
