//
//  User.swift
//  TawuniyaTask
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

extension User: ManagedObjectConvertible {
    public func createManageObject(context: NSManagedObjectContext) -> UserMO? {
        let userMO = context.create(UserMO.self) as? UserMO
        if let id {
            userMO?.userId = NSDecimalNumber(value: id)
        }
        if let isLiked {
            userMO?.isLiked = isLiked
        }
        
        return userMO
    }
}
