//
//  UserMO+CoreDataProperties.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 04/12/2024.
//
//

import Foundation
import CoreData

extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserEntity")
    }

    @NSManaged public var userId: NSDecimalNumber?
    @NSManaged public var isLiked: Bool

}

extension UserMO : Identifiable {

}

extension UserMO: DomainConvertible {
    public func toDomain() -> User? {
        .init(id: userId?.intValue, isLiked: isLiked)
    }
}
