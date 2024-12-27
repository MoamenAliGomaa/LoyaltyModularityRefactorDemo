//
//  UserRowViewModel.swift
//  LoyaltyModularityRefactorDemo
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
    private var cancelBag = Set<AnyCancellable>()
    private var user: User
    let id: Int
    
    init(user: User) {
        self.name = user.name ?? "Unknown Name"
        self.username = user.username ?? "Unknown Username"
        self.email = user.email ?? "Unknown Email"
        self.companyName = user.companyName ?? "Unknown Company"
        self.cityName = user.cityName ?? "Unknown City"
        self.isLiked = user.isLiked ?? false
        self.user = user
        self.id = user.id ?? 0
    }
}
