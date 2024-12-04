//
//  UsersListViewModel.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetchAllUsersUseCase: GetAllUsersUseCase
    private let saveUserUseCase: SaveUserUseCase
    private let deleteUserUseCase: DeleteUserUseCase
    
    init(
        fetchAllUsersUseCase: GetAllUsersUseCase,
        saveUserUseCase: SaveUserUseCase,
        deleteUserUseCase: DeleteUserUseCase
    ) {
        self.fetchAllUsersUseCase = fetchAllUsersUseCase
        self.saveUserUseCase = saveUserUseCase
        self.deleteUserUseCase = deleteUserUseCase
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
                    let rowViewModels = users.compactMap {[weak self] in
                        UserRowViewModel(
                            user: $0,
                            saveUserUseCase: self?.saveUserUseCase,
                            deleteUserUseCase: self?.deleteUserUseCase
                        )
                    }
                    self?.state = rowViewModels.isEmpty ? .empty : .success(rowViewModels)
                }
            })
            .store(in: &cancellables)
    }
}
