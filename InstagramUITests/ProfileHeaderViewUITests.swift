//
//  ProfileHeaderViewUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 10.06.2024..
//

import XCTest

final class ProfileHeaderViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testFollowButtonFunctionality() {
        let followButton = app.buttons["followButton"]
        XCTAssertTrue(followButton.exists, "Follow button should exist.")
        followButton.tap()
        let expectedLabel = "Following"
        XCTAssertEqual(followButton.label, expectedLabel, "Follow button label should change to 'Following'.")
    }
    
    func testEditProfileNavigatesCorrectly() {
        let editButton = app.buttons["editProfileButton"]
        XCTAssertTrue(editButton.exists, "Edit Profile button should exist.")
        editButton.tap()
        XCTAssertTrue(app.otherElements["EditProfileView"].exists, "Should navigate to Edit Profile view.")
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
