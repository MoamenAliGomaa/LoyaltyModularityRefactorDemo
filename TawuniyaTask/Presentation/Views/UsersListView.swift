//
//  UsersListView.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation
import SwiftUI
import Combine

struct UsersListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
                    .padding()
            case .success(let rowViewModels):
                if let viewModels = rowViewModels as? [UserRowViewModel]{
                    NavigationView(content: {
                        List(viewModels) { rowViewModel in
                            UserRowView(viewModel: rowViewModel)
                        }
                    }).navigationTitle("Users")
                }
            case .failed(let errorMessage):
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            case .empty:
                Text("No users available")
                    .foregroundColor(.gray)
                    .padding()
            }
        }.onAppear {
            viewModel.fetchUsers()
        }
    }
}
