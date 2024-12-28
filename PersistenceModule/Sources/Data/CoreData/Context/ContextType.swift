//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation
// MARK: - Enums
public enum ContextType {
    case main
    case writing
    
    var configuration: ContextConfiguration {
        switch self {
        case .main:
            return ContextConfiguration(
                mergesChanges: true,
                name: "mainContext",
                author: "mainOperations"
            )
        case .writing:
            return ContextConfiguration(
                mergesChanges: true,
                name: "writingContext",
                author: "writingOperations"
            )
        }
    }
}
