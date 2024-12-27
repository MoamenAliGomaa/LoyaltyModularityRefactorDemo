//
//  NetworkServices.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Codable>(
        _ request: RequestBuilder,
        responseType: T?.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    )
}
