//
//  ManagedObjectConvertible.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import CoreData

public protocol ManagedObjectConvertible {
    associatedtype ManagedObjectType

    @discardableResult
    func createManageObject(context: NSManagedObjectContext) -> ManagedObjectType?
}
