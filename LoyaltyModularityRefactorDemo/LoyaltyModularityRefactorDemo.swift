//
//  LoyaltyModularityRefactorDemoApp.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import SwiftUI
import PersistenceModule

@main
struct LoyaltyModularityRefactorDemoApp: App {

    var body: some Scene {
        WindowGroup {
            let coreDataConfigs = CoreDataConfiguration(
                modelName: "CashModel",
                bundleIdentifier: "moamen.ali.LoyaltyModularityRefactorDemo"
            )
            let persistentStore = try! CoreDataPersistentStore(
                configuration: coreDataConfigs
            )
            let coreDataService = MainCoreDataService(persistentStore: persistentStore)
            let entityTransformer = CasheEntityTransformer()
            let casheService = PersistenceRepository(
                coreDataService: coreDataService,
                transformer: entityTransformer
            )
            let cashRepository = CoreDataCacheRepository(
                repository: casheService,
                expirationDuration: 60
            )
            let networkService = NetworkService()
            let neworkCashProxy = CachingNetworkProxy(
                networkService: networkService,
                cache: cashRepository
            )
            let userRepository = UserRepository(
                proxy: neworkCashProxy,
                persistenceRepository: casheService
            )
            let getAllUsersUseCase = GetAllUsersUseCase(repository: userRepository)
            let viewModel = UserListViewModel(
                fetchAllUsersUseCase: getAllUsersUseCase
            )
            UsersListView(viewModel: viewModel)
        }
    }
}
