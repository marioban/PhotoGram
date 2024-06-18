//
//  UploadPostViewUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 10.06.2024..
//

import XCTest

final class UploadPostViewUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testUploadPostButtonEnabled() {
        let uploadButton = app.buttons["uploadButton"]
        XCTAssertTrue(uploadButton.exists, "Upload button should exist.")
        let textField = app.textFields["captionTextField"]
        textField.tap()
        textField.typeText("Sample Post Caption")
        XCTAssertTrue(uploadButton.isEnabled, "Upload button should be enabled after entering text.")
    }
    
    func testNavigateToLocationPicker() {
        let locationButton = app.buttons["locationButton"]
        XCTAssertTrue(locationButton.exists, "Location button should exist.")
        locationButton.tap()
        XCTAssertTrue(app.maps.element.exists, "Should navigate to Map view for location selection.")
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
