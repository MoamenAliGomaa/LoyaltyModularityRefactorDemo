//
//  URLSessionNetworkLayer.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        configuration: URLSessionConfiguration = .default,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = URLSession(configuration: configuration)
        self.decoder = decoder
    }
    
    func request<T: Codable>(
        _ request: any RequestBuilder,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        performRequest(request, responseType: responseType, completion: completion)
    }
    
    private func performRequest<T: Codable>(
        _ request: RequestBuilder,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        do {
            let urlRequest = try request.asURLRequest()
            
            let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(.custom(error)))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let data = data, !data.isEmpty {
                            do {
                                let decoded = try self.decoder.decode(T?.self, from: data)
                                completion(.success(decoded))
                            } catch {
                                completion(.failure(.decodingFailed))
                            }
                        } else {
                            completion(.success(nil))
                        }
                        
                    case 401:
                        completion(.failure(.unauthorized))
                        
                    default:
                        completion(.failure(.serverError(httpResponse.statusCode)))
                    }
                }
            }
            task.resume()
            
        } catch {
            completion(.failure(.custom(error)))
        }
    }
}
