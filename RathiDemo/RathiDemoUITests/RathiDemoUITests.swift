//
//  RathiDemoUITests.swift
//  RathiDemoUITests
//
//  Created by Rathi Shetty on 12/12/24.
//

import XCTest

class RathiDemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Launch the app before each test
        app = XCUIApplication()
        app.launch()
        sleep(2)
    }
    
    override func tearDown() {
        // Clean up after each test
        app = nil
        super.tearDown()
    }
    
    // MARK: - Test for App Launch
    
    func testAppLaunchesSuccessfully() {
        // Assert that the app launches and the main view appears
        XCTAssertTrue(app.navigationBars["Coin"].exists)
    }
    
    // MARK: - Test for Fetching Cryptos
    
    func testFetchCryptos() {
        // Verify that the activity indicator is visible when fetching data
        let loadingIndicator = app.activityIndicators["ActivityIndicator"]
        
        // Wait for the loading indicator to disappear after fetching is complete
        let predicate = NSPredicate(format: "exists == false")
        expectation(for: predicate, evaluatedWith: loadingIndicator, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Verify that the crypto list is visible
        let tableView = app.tables["CryptoTableView"]
        XCTAssertTrue(tableView.exists)
    }
    
    // MARK: - Test for Table View Data
    
    func testDisplayCryptos() {
        // Verify that the activity indicator is visible when fetching data
        let loadingIndicator = app.activityIndicators["ActivityIndicator"]
        
        // Wait for the loading indicator to disappear after fetching is complete
        let predicate = NSPredicate(format: "exists == false")
        expectation(for: predicate, evaluatedWith: loadingIndicator, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assuming there's at least one row in the table
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        
        let nameLabel = firstCell.staticTexts["CryptoNameLabel-Bitcoin"]
        XCTAssertEqual(nameLabel.label, "Bitcoin")
    }

    // MARK: - Test for Toggle Search Bar
    
    func testToggleSearchBar() {
        
        // Find and tap the search bar icon in the navigation bar
        let searchButton = app.navigationBars.buttons["Search"]
        searchButton.tap()
        
        // Verify that the search bar is shown
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists)
        
        // Hide the search bar
        searchButton.tap()
        XCTAssertFalse(searchBar.exists)
    }
    
    // MARK: - Test for Applying Active Filter
    
    func testActiveFilter() {
        
        let activeFilterButton = app.buttons["Active Coins"]
        activeFilterButton.tap()
        
        // Verify that only active cryptos are displayed
        
        let firstCell = app.tables.cells.element(boundBy: 1)
        let symbolLabel = firstCell.staticTexts["CryptoNameLabel-ETH"]
        XCTAssertTrue(symbolLabel.exists)
    }
    
    // MARK: - Test for Applying Inactive Filter
    
    func testInactiveFilter() {
        let inactiveFilterButton = app.buttons["Inactive Coins"]
        inactiveFilterButton.tap()
                
        // Verify that only inactive cryptos are displayed
        let firstCell = app.tables.cells.element(boundBy: 2)
        let symbolLabel = firstCell.staticTexts["CryptoNameLabel-SUSHI"]
        XCTAssertTrue(symbolLabel.exists)
    }
    
    // MARK: - Test for Reset Filters
    
    func testResetFilters() {
        // Apply active filter
        let activeFilterButton = app.staticTexts["Inactive Coins"]
        activeFilterButton.tap()
        XCTAssertTrue(activeFilterButton.exists)

        let symbolLabel = app.tables.cells.element(boundBy: 0).staticTexts["CryptoNameLabel-XRP"]
        XCTAssertEqual(symbolLabel.label, "CryptoNameLabel-XRP")

        activeFilterButton.tap()
        
        let btcSymbolLabel = app.tables.cells.element(boundBy: 0).staticTexts["CryptoNameLabel-BTC"]
        XCTAssertEqual(btcSymbolLabel.label, "CryptoNameLabel-BTC")

        
    }
    
    // MARK: - Test for Scrolling the List
    
    func testScrollCryptoList() {
        let tableView = app.tables["CryptoTableView"]
        
        // Swipe up to scroll the list
        tableView.swipeUp()
        
        // Verify that the table can be scrolled and more rows are visible
        let lastCell = tableView.cells.element(boundBy: 9)
        XCTAssertTrue(lastCell.exists)
    }
}
