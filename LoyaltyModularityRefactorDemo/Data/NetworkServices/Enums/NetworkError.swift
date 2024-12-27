//
//  NetworkError.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 26/12/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case invalidResponse
    case serverError(Int)
    case unauthorized
    case noConnection
    case custom(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingFailed:
            return "Failed to decode response"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .noConnection:
            return "No internet connection"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}
