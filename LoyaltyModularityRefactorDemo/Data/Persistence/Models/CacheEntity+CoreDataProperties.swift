//
//  CacheEntity+CoreDataProperties.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 27/12/2024.
//
//

import Foundation
import CoreData
import PersistenceModule


extension CacheEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CacheEntity> {
        return NSFetchRequest<CacheEntity>(entityName: "CacheEntity")
    }

    @NSManaged public var key: String?
    @NSManaged public var data: Data?
    @NSManaged public var timestamp: Date?

}

extension CacheEntity : Identifiable {

}

extension CacheEntity {
    func store<T: Codable>(_ object: T) throws {
        self.data = try JSONEncoder().encode(object)
        self.timestamp = Date()
        self.key = String(describing: type(of: T.self))
    }
    
    func decode<T: Codable>() throws -> T {
        guard let data = self.data else {
            throw CoreDataError.invalidEntityType
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension CacheEntity: DomainEntity {
    public typealias ID = String
    
    public var id: ID {
        return key ?? ""
    }
}
