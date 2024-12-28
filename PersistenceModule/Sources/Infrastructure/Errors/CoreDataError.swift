//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 07/11/2024.
//

import Foundation

public enum CoreDataError: Error, LocalizedError {
    case entityNotFound
    case saveFailed(Error?)
    case fetchFailed(Error?)
    case deleteFailed(Error?)
    case batchInsertError
    case contextInitializationError
    case invalidManagedObject
    case bundleNotFound
    case modelNotFound
    case invalidModel
    case storeDescriptionNotFound
    case invalidEntityType
    
    public var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "The requested entity could not be found in the Core Data model."
        case .saveFailed(let error):
            guard let error else {
                return "Failed to save the changes to Core Data."
            }
            
            return error.localizedDescription
        case .fetchFailed(let error):
            guard let error else {
                return "Failed to fetch data from Core Data."
            }
            
            return error.localizedDescription
        case .deleteFailed(let error):
            guard let error else {
                return "Failed to delete the object from Core Data."
            }
            
            return error.localizedDescription
        case .batchInsertError:
            return "Failed to perform batch insert in Core Data."
        case .contextInitializationError:
            return "Failed to initialize the Core Data context."
        case .invalidManagedObject:
            return "Invalid managed object encountered."
        case .bundleNotFound:
            return "Could not find bundle with specified identifier"
        case .modelNotFound:
            return "Could not find Core Data model in bundle"
        case .invalidModel:
            return "Could not create managed object model"
        case .storeDescriptionNotFound:
            return "Could not find persistent store description"
        case .invalidModel:
            return "Invalid model type"
        case .invalidEntityType:
            return "Invalid Entity Type"
        }
    }
}
