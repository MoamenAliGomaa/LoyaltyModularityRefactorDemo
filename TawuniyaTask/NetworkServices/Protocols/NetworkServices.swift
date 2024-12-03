//
//  NetworkServices.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import Combine

protocol NetworkLayer {
    func request<T: Decodable>(builder: RequestBuilder) -> AnyPublisher<T, Error>
}
