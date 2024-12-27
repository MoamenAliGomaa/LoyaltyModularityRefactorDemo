//
//  ViewState.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 04/12/2024.
//

import Foundation

enum ViewState {
    case loading
    case success([any RowViewModel]?)
    case failed(String)
    case empty
}
