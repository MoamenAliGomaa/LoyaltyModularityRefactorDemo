//
//  Address.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}
