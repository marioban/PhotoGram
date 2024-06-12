//
//  FeedViewUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 10.06.2024..
//

import XCTest

final class FeedViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testNavigationToSavedPosts() {
        let bookmarkButton = app.buttons["bookmark"]
        XCTAssertTrue(bookmarkButton.exists, "Bookmark button should be visible on the feed screen")
        
        bookmarkButton.tap()
        XCTAssertTrue(app.otherElements["SavedFeedView"].exists, "Should navigate to the saved posts view")
    }
    
    func testLoadingAnimation() {
        let loadingText = app.staticTexts["Loading posts..."]
        XCTAssertTrue(loadingText.exists, "Loading animation should be visible when posts are being loaded")
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
