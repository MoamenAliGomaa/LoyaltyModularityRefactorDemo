//
//  CashedDomainResponse.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 26/12/2024.
//

import Foundation
import PersistenceModule
import CoreData

struct CashedDomainResponse {
    let key: String
    let data: Data?
    let timestamp: Date
}

extension CashedDomainResponse: DomainEntity {
    typealias ID = String
    var id: ID {
        return key
    }
}
