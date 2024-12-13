//
//  RathiCryptoDemoTests.swift
//  RathiCryptoDemoTests
//
//  Created by Rathi Shetty on 12/12/24.
//

import XCTest
@testable import RathiCryptoDemo

final class RathiCryptoDemoTests: XCTestCase {
    
    var viewModel: CryptoListViewModel!
    var mockService: MockCryptoService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCryptoService()
        viewModel = CryptoListViewModel(cryptoService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchCryptosSuccess() {
        let expectation = self.expectation(description: "Fetch cryptos success")
        
        // Here we let the mock service read from the mock JSON
        mockService.result = nil
        
        viewModel.onUpdate = {
            XCTAssertEqual(self.viewModel.numberOfRows(), 26)
            XCTAssertEqual(self.viewModel.getCrypto(at: 0).name, "Bitcoin")
            XCTAssertEqual(self.viewModel.getCrypto(at: 1).name, "Ethereum")
            expectation.fulfill()
        }
        
        viewModel.fetchCryptos()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchCryptosFailure() {
        mockService.result = .failure(NSError(domain: "Test", code: 0, userInfo: nil))
        
        let expectation = self.expectation(description: "Fetch cryptos failure")
        viewModel.onError = { errorMessage in
            XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (Test error 0.)")
            expectation.fulfill()
        }
        
        viewModel.fetchCryptos()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testEmptyStateWhenNoCryptos() {
        // Arrange: Set the mock service to return an empty array
        mockService.result = .success([])
        
        let expectation = self.expectation(description: "Table view shows empty state")
        
        // Act: Fetch cryptos and check for empty state
        viewModel.onUpdate = {
            // Assert: Verify the number of rows in the table view is 0 (empty state)
            XCTAssertEqual(self.viewModel.numberOfRows(), 0)
            
            expectation.fulfill()
        }
        
        viewModel.fetchCryptos()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testErrorHandlingOnFetchFailure() {
        // Arrange: Set the mock service to return a failure
        let error = NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockService.result = .failure(error)
        
        let expectation = self.expectation(description: "Error message displayed")
        
        // Act: Fetch cryptos and check if error message is shown
        viewModel.onError = { errorMessage in
            // Assert: Verify that the error message matches the expected one
            XCTAssertEqual(errorMessage, "Network error")
            
            expectation.fulfill()
        }
        
        viewModel.fetchCryptos()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

