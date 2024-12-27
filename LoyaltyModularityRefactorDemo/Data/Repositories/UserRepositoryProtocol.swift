//
//  UserRepositoryProtocol.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func fetchRemotUsers() -> AnyPublisher<[UserDTO], Error>
}
