//
//  DomainConvertible.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import CoreData

public protocol DomainConvertible {
    associatedtype Domain

    /// Converts a conforming instance to a data model instance.
    ///
    /// - Returns: The converted data model instance.
    @discardableResult
    func toDomain() -> Domain?
}
