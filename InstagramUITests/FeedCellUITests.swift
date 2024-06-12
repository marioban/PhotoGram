//
//  FeedCellUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 10.06.2024..
//

import XCTest

final class FeedCellUITests: XCTestCase {

    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testLikeButtonToggle() {
        let likeButton = app.buttons["likeButton"]
        XCTAssertTrue(likeButton.exists, "Like button should exist.")
        likeButton.tap()
        XCTAssertTrue(likeButton.label.contains("fill"), "Like button should toggle to filled state on tap.")
    }
    
    func testSaveButtonToggle() {
        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.exists, "Save button should exist.")
        saveButton.tap()
        XCTAssertTrue(saveButton.label.contains("fill"), "Save button should toggle to filled state on tap.")
    }
    
    func testDownloadImage() {
        let downloadButton = app.buttons["downloadButton"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: downloadButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)   button to appear
        
        XCTAssertTrue(downloadButton.exists, "Download button should exist.")
        downloadButton.tap()

        let downloadCompleteAlert = app.alerts["Download Complete"]
        let existsAlert = NSPredicate(format: "exists == true")
        expectation(for: existsAlert, evaluatedWith: downloadCompleteAlert, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        let alertText = downloadCompleteAlert.staticTexts["Image has been saved to your Photos. Open the Photos app to view it."]
        XCTAssertTrue(alertText.exists, "Download alert should appear after tapping download button.")
    }



    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
