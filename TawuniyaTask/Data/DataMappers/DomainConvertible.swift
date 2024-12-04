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

    func toDomain() -> Domain?
}
