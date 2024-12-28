//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
import CoreData

public protocol DomainEntity {
    associatedtype ID: Hashable
    var id: ID { get }
}
