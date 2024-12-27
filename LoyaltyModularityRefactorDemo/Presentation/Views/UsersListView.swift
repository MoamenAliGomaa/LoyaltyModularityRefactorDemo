//
//  UsersListView.swift
//  LoyaltyModularityRefactorDemo
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
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModels) { rowViewModel in
                                UserRowView(viewModel: rowViewModel)
                            }
                        }.padding()
                    }
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
