//
//  UserRowViewModel.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import Combine

class UserRowViewModel: RowViewModel {
    @Published var name: String
    @Published var username: String
    @Published var email: String
    @Published var companyName: String
    @Published var cityName: String
    @Published var isLiked: Bool
    private var saveUserUseCase: SaveUserUseCase?
    private var deleteUserUseCase: DeleteUserUseCase?
    private var cancelBag = Set<AnyCancellable>()
    private var user: User
    let id: Int
    
    init(user: User, saveUserUseCase: SaveUserUseCase?, deleteUserUseCase: DeleteUserUseCase?) {
        self.name = user.name ?? "Unknown Name"
        self.username = user.username ?? "Unknown Username"
        self.email = user.email ?? "Unknown Email"
        self.companyName = user.companyName ?? "Unknown Company"
        self.cityName = user.cityName ?? "Unknown City"
        self.isLiked = user.isLiked ?? false
        self.user = user
        self.saveUserUseCase = saveUserUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.id = user.id ?? 0
    }
    
    private func saveUser() {
        do {
            guard let saveUserUseCase else { return }
            try  saveUserUseCase.execute(user: user)
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    private func deleteUser() {
        do {
            guard let deleteUserUseCase else { return }
            try deleteUserUseCase.execute(user: user)
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }
    
    func toggleLike() {
        if isLiked == true {
            deleteUser()
        } else {
            saveUser()
        }
        isLiked.toggle()
    }
}
