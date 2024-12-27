//
//  APIRouter.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

enum APIRouter: RequestBuilder {
    var cachePolicy: CachePolicy {
        return .useCache(maxAge: 400)
    }
    case getUsers
    var mainURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    var path: String {
        return "/users"
    }
    var method: HTTPMethod {
        return .get
    }
}
