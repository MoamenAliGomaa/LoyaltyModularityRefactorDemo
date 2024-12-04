//
//  CoreDataErrors.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

enum CoreDataError: Error, LocalizedError {
    case entityNotFound
    case saveFailed
    case fetchFailed
    case deleteFailed
    case batchInsertError
    case contextInitializationError
    case invalidManagedObject

    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "The requested entity could not be found in the Core Data model."
        case .saveFailed:
            return "Failed to save the changes to Core Data."
        case .fetchFailed:
            return "Failed to fetch data from Core Data."
        case .deleteFailed:
            return "Failed to delete the object from Core Data."
        case .batchInsertError:
            return "Failed to perform batch insert in Core Data."
        case .contextInitializationError:
            return "Failed to initialize the Core Data context."
        case .invalidManagedObject:
            return "Invalid managed object encountered."
        }
    }
}
