//
//  Constants.swift
//  RathiCryptoDemo
//
//  Created by Rathi Shetty on 13/12/24.
//

import Foundation

enum APIRequestContants {
    static let baseURL = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
}

enum ScreenTitle {
    static let coin = "Coin"
}

enum UIStrings {
    static let search = "Search"
}

enum FilterType: String {
    case activeCoins = "Active Coins"
    case inactiveCoins = "Inactive Coins"
    case onlyTokens = "Only Tokens"
    case onlyCoins = "Only Coins"
    case newCoins = "New Coins"
}
