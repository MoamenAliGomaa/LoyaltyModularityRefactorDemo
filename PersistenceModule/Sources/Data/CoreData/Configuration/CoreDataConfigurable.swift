//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation

public protocol CoreDataConfigurable {
    var modelName: String { get }
    var bundleIdentifier: String { get }
    var shouldMigrateStore: Bool { get }
    var inMemory: Bool { get }
}
