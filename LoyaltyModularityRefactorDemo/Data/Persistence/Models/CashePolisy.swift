//
//  CashePolisy.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 26/12/2024.
//

import Foundation

// MARK: - Cache Policy
public enum CachePolicy {
    case ignoreCache
    case useCache(maxAge: TimeInterval)
}
