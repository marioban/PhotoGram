//
//  FeedViewUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 03.09.2024..
//
import XCTest

final class FeedViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testFeedViewBasicStructure() throws {
        // Test navigation title
        XCTAssertTrue(app.navigationBars["Feed"].exists)
        
        // Test Instagram logo presence
        XCTAssertTrue(app.images["Instagram_logo"].exists)
        
        // Test scroll view presence
        XCTAssertTrue(app.scrollViews.firstMatch.exists)
    }
}
