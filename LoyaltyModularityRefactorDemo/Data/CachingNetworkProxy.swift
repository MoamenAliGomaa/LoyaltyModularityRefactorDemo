//
//  CachingNetworkProxy.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 27/12/2024.
//

import Foundation

final class CachingNetworkProxy: NetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let cache: CacheRepositoryProtocol
    
    init(
        networkService: NetworkServiceProtocol,
        cache: CacheRepositoryProtocol
    ) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func request<T: Codable>(
        _ request: any RequestBuilder,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        let cacheKey = generateCacheKey(for: request)
        
        switch request.cachePolicy {
        case .useCache(let maxAge):
            handleCachedRequest(request, cacheKey: cacheKey, maxAge: maxAge, responseType: responseType, completion: completion)
        case .ignoreCache:
            networkService.request(request, responseType: responseType) { [weak self] result in
                self?.handleNetworkResponse(result, request: request, cacheKey: cacheKey, completion: completion)
            }
        }
    }
    
    private func handleCachedRequest<T: Codable>(
        _ request: RequestBuilder,
        cacheKey: String,
        maxAge: TimeInterval,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        cache.retrieve(forKey: cacheKey) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cachedResponse):
                if let data = cachedResponse?.data {
                    do {
                        let decoded = try JSONDecoder().decode(T?.self, from: data)
                        completion(.success(decoded))
                    } catch {
                        self.fetchFromNetwork(request, cacheKey: cacheKey, responseType: responseType, completion: completion)
                    }
                } else {
                    self.fetchFromNetwork(request, cacheKey: cacheKey, responseType: responseType, completion: completion)
                }
            case .failure:
                self.fetchFromNetwork(request, cacheKey: cacheKey, responseType: responseType, completion: completion)
            }
        }
    }
    
    private func fetchFromNetwork<T: Codable>(
        _ request: RequestBuilder,
        cacheKey: String,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        networkService.request(request, responseType: responseType) { [weak self] result in
            self?.handleNetworkResponse(result, request: request, cacheKey: cacheKey, completion: completion)
        }
    }
    
    private func handleNetworkResponse<T: Codable>(
        _ result: Result<T?, NetworkError>,
        request: RequestBuilder,
        cacheKey: String,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    ) {
        switch result {
        case .success(let data):
            if let encodedData = try? JSONEncoder().encode(data) {
                cache.save(
                    CashedDomainResponse(
                        key: cacheKey,
                        data: encodedData,
                        timestamp: Date()
                    )
                ) { _ in
                    completion(.success(data))
                }
            } else {
                completion(.success(data))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func generateCacheKey(for request: RequestBuilder) -> String {
        var components = [
            request.mainURL,
            request.path,
            request.method.rawValue
        ]
        
        if let parameters = request.parameters?.description {
            components.append(parameters)
        }
        
        if let body = request.body {
            components.append(body.description)
        }
        
        return components.joined(separator: "_").data(using: .utf8)!.base64EncodedString()
    }
}
