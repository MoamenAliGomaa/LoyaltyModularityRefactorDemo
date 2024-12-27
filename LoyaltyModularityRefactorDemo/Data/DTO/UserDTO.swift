//
//  UserDTO.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

class UserDTO: Codable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: AddressDTO?
    let phone: String?
    let website: String?
    let company: CompanyDTO?
}

extension UserDTO: DomainConvertible {

    func toDomain() -> User? {
        .init(
            id: id,
            name: name,
            username: username,
            email: email,
            companyName: company?.name,
            cityName: address?.city
        )
    }
}
