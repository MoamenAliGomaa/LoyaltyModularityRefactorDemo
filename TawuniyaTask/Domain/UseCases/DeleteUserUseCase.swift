//
//  DeleteUserUseCase.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation

class DeleteUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(user: User) throws {
        try repository.delete(user: user)
    }
}
