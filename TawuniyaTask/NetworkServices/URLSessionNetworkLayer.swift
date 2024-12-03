//
//  URLSessionNetworkLayer.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

class URLSessionNetworkLayer: NetworkLayer {
    func request<T: Decodable>(builder: RequestBuilder) -> AnyPublisher<T, Error> {
        guard let url = builder.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = builder.method.rawValue
        builder.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let parameters = builder.parameters,
           builder.method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
