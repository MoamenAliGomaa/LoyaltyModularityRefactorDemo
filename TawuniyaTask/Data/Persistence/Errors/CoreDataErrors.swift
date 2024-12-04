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

    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "The requested entity could not be found in the Core Data model."
        case .saveFailed:
            return "Failed to save the changes to Core Data."
        }
    }
}
