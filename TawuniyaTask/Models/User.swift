//
//  User.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
// MARK: - Models

struct User: Codable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}
