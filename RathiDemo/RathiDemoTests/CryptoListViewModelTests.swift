//
//  CryptoListViewModelTests.swift
//  RathiDemoTests
//
//  Created by Rathi Shetty on 12/12/24.
//

import XCTest

@testable import RathiDemo

class CryptoListViewModelTests: XCTestCase {
    var viewModel: CryptoListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CryptoListViewModel()
    }
    
    func testApplyFilters() {
        let testData = [
            Crypto(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            Crypto(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: "token"),
            Crypto(name: "Beta Token", symbol: "BETA", isNew: true, isActive: false, type: "token")
        ]
        viewModel.cryptos = testData
        viewModel.applyFilters(isActive: true)
        
        XCTAssertEqual(viewModel.numberOfRows(), 2) // Only active cryptos
    }
    
    func testSearch() {
        let testData = [
            Crypto(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: "coin"),
            Crypto(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: "token")
        ]
        viewModel.cryptos = testData
        viewModel.search(query: "Bitcoin")
        
        XCTAssertEqual(viewModel.numberOfRows(), 1) // Search by name
    }
}
