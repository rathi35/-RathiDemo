//
//  CryptoListViewModel.swift
//  RathiDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import Foundation

/// ViewModel for managing crypto data and filters
class CryptoListViewModel {
    var cryptos: [Crypto] = []          // Original list of cryptocurrencies
    private var filteredCryptos: [Crypto] = [] // Filtered list of cryptocurrencies
    private let cryptoService = CryptoService()
    
    var onUpdate: (() -> Void)?    // Callback to notify when data updates
    var onError: ((String) -> Void)? // Callback to notify when an error occurs
    
    /// Fetch cryptos from the API
    func fetchCryptos() {
        cryptoService.fetchCoins(request: .crypoList) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.cryptos = coins
                    self?.filteredCryptos = coins
                    self?.onUpdate?() // Notify the UI to update
                case .failure(let error):
                    self?.onError?(error.localizedDescription) // Notify the UI of errors
                }
            }
        }
    }
    
    /// Apply filters to the list of cryptos
    /// - Parameters:
    ///   - isActive: Show only active cryptos if true
    ///   - isNew: Show only new cryptos if true
    ///   - type: Filter by type (e.g., "coin", "token")
    func applyFilters(isActive: Bool? = nil, isNew: Bool? = nil, type: FilterType? = nil) {
        filteredCryptos = cryptos.filter { crypto in
            var matches = true
            if let isActive = isActive {
                matches = matches && crypto.isActive == isActive
            }
            if let isNew = isNew {
                matches = matches && crypto.isNew == isNew
            }
            if let type = type {
                matches = matches && crypto.type == type.rawValue
            }
            return matches
        }
        onUpdate?() // Notify the UI to update
    }
    
    /// Perform a search on the list of cryptos
    /// - Parameter query: Search term for name or symbol
    func search(query: String) {
        if query.isEmpty {
            filteredCryptos = cryptos
        } else {
            filteredCryptos = filteredCryptos.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.symbol.localizedCaseInsensitiveContains(query)
            }
        }
        onUpdate?()
    }
    
    /// Get the crypto object at a specific index
    /// - Parameter index: Index in the filtered list
    func getCrypto(at index: Int) -> Crypto {
        return filteredCryptos[index]
    }
    
    /// Get the number of filtered cryptos
    func numberOfRows() -> Int {
        return filteredCryptos.count
    }
}

