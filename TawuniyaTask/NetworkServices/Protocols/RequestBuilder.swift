//
//  RequestBuilder.swift
//  TawuniyaTask
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
}

extension RequestBuilder {
    var url: URL? {
        guard var url = URL(string: mainURL) else {
            return nil
        }
        url.appendPathComponent(path)
        return url
    }
}
