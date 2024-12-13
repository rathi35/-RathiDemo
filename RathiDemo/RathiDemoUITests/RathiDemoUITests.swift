//
//  RathiDemoUITests.swift
//  RathiDemoUITests
//
//  Created by Rathi Shetty on 12/12/24.
//

import XCTest

class RathiDemoUITests: XCTestCase {
    func testSearchBarFunctionality() {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("Bitcoin")
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["Bitcoin (BTC)"].exists)
    }
}
