//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation

public struct CoreDataConfiguration: CoreDataConfigurable {
    public let modelName: String
    public let bundleIdentifier: String
    public let shouldMigrateStore: Bool
    public let inMemory: Bool
    
    public init(modelName: String,
                bundleIdentifier: String,
                shouldMigrateStore: Bool = true,
                inMemory: Bool = false) {
        self.modelName = modelName
        self.bundleIdentifier = bundleIdentifier
        self.shouldMigrateStore = shouldMigrateStore
        self.inMemory = inMemory
    }
}
