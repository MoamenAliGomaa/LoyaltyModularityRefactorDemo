//
//  User.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import CoreData

public class User {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let companyName: String?
    let cityName: String?
    var isLiked: Bool?
    
    init(
        id: Int? = nil,
        name: String? = nil,
        username: String? = nil,
        email: String? = nil,
        companyName: String? = nil,
        cityName: String? = nil,
        isLiked: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.companyName = companyName
        self.cityName = cityName
        self.isLiked = isLiked
    }
}

extension User: Encodable{
    func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toCashResp() throws -> CashedDomainResponse? {
        return try .init(key: "\(self.id ?? 0)", data: toData(), timestamp: Date())
    }
}
