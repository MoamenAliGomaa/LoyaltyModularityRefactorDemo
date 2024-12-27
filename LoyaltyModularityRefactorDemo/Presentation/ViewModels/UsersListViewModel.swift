//
//  UsersListViewModel.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetchAllUsersUseCase: GetAllUsersUseCase
    
    init(
        fetchAllUsersUseCase: GetAllUsersUseCase
    ) {
        self.fetchAllUsersUseCase = fetchAllUsersUseCase
    }
    
    func fetchUsers() {
        fetchAllUsersUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failed("Failed to fetch data: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] users in
                DispatchQueue.main.async {[weak self] in
                    let rowViewModels = users.compactMap { 
                        UserRowViewModel(
                            user: $0
                        )
                    }
                    self?.state = rowViewModels.isEmpty ? .empty : .success(rowViewModels)
                }
            })
            .store(in: &cancellables)
    }
}
