//
//  CryptoListViewModel.swift
//  RathiCryptoDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import Foundation

/// ViewModel for managing crypto data and filters
class CryptoListViewModel {
    var cryptos: [Crypto] = []          // Original list of cryptocurrencies
    private var filteredCryptos: [Crypto] = [] // Filtered list of cryptocurrencies
    private let cryptoService: CryptoService
    
    var selectedFilters: [FilterType] = []
    
    var onUpdate: (() -> Void)?    // Callback to notify when data updates
    var onError: ((String) -> Void)? // Callback to notify when an error occurs
    
    
    init(cryptoService: CryptoService) {
          self.cryptoService = cryptoService
      }
    
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
    func applyFilters() {
        filteredCryptos = cryptos.filter { crypto in
            var matches = true
            if selectedFilters.contains(.activeCoins) {
                matches = matches && crypto.isActive
            }
            if selectedFilters.contains(.inactiveCoins) {
                matches = matches && !crypto.isActive
            }
            if selectedFilters.contains(.newCoins) {
                matches = matches && crypto.isNew
            }
            if selectedFilters.contains(.onlyCoins) {
                matches = matches && crypto.type == "coin"
            }
            if selectedFilters.contains(.onlyTokens) {
                matches = matches && crypto.type == "token"
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
            filteredCryptos = cryptos.filter {
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

