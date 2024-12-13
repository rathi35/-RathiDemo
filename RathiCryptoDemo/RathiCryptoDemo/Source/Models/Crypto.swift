//
//  Crypto.swift
//  RathiCryptoDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

/// Represents a cryptocurrency object
struct Crypto: Codable {
    let name: String       // Name of the cryptocurrency (e.g., "Bitcoin")
    let symbol: String     // Symbol of the cryptocurrency (e.g., "BTC")
    let isNew: Bool        // Whether the cryptocurrency is new
    let isActive: Bool     // Whether the cryptocurrency is active
    let type: String       // Type of the cryptocurrency (e.g., "coin", "token")
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}
