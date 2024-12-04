//
//  TawuniyaTaskApp.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import SwiftUI

@main
struct TawuniyaTaskApp: App {

    var body: some Scene {
        WindowGroup {
            let context = CoreDataStack.shared.context
            let localDataService = CoreDataService(context: context)
            let networkLayer = URLSessionNetworkLayer()
            let userRepository = UserRepository(
                networkLayer: networkLayer,
                localDataService: localDataService
            )
            let getAllUsersUseCase = GetAllUsersUseCase(repository: userRepository)
            let saveUserUseCase = SaveUserUseCase(repository: userRepository)
            let deleteUserUseCase = DeleteUserUseCase(repository: userRepository)
            let viewModel = UserListViewModel(
                fetchAllUsersUseCase: getAllUsersUseCase,
                saveUserUseCase: saveUserUseCase,
                deleteUserUseCase: deleteUserUseCase
            )
            UsersListView(viewModel: viewModel)
        }
    }
}
