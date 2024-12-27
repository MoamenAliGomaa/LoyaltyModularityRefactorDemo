//
//  RequestBuilder.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

protocol RequestBuilder {
    var mainURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: CachePolicy { get }
}

// MARK: - Default Implementation
extension RequestBuilder {
    var headers: [String: String]? { return nil }
    var parameters: [String: Any]? { return nil }
    var body: Data? { return nil }
    var timeoutInterval: TimeInterval { return 30 }
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: mainURL + path) else {
            throw NetworkError.invalidURL
        }
        
        // Add query parameters
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        var defaultHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let headers = headers {
            defaultHeaders.merge(headers) { _, new in new }
        }
        
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
