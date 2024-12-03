//
//  APIRouter.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

enum APIRouter: RequestBuilder {
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
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
}
