//
//  FeedCellUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 03.09.2024..
//

import XCTest

final class FeedCellUITests: XCTestCase {


    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testLikeButtonToggles() throws {
        // Assuming the app launches directly to the FeedView containing FeedCells
        let firstCell = app.scrollViews.otherElements["FeedCell"].firstMatch

        // Find the like button (heart icon)
        let likeButton = firstCell.buttons["heart"]

        // Tap the like button
        likeButton.tap()

        // After tapping, the button should be filled (heart.fill)
        let filledHeartButton = firstCell.buttons["heart.fill"]
        XCTAssertTrue(filledHeartButton.exists, "Like button should be filled after tapping")

        // Tap again to unlike
        filledHeartButton.tap()

        // Verify it returns to the empty heart state
        XCTAssertTrue(likeButton.exists, "Like button should return to unfilled after unliking")
    }

    func testDownloadButtonShowsAlert() throws {
        let firstCell = app.scrollViews.otherElements["FeedCell"].firstMatch

        // Find the download button (arrow.down.to.line)
        let downloadButton = firstCell.buttons["arrow.down.to.line"]

        // Tap the download button
        downloadButton.tap()

        // Ensure the alert shows up after tapping the download button
        let downloadAlert = app.alerts["Download Complete"]
        XCTAssertTrue(downloadAlert.waitForExistence(timeout: 5), "Download alert should appear after tapping the download button")

        // Dismiss the alert
        downloadAlert.buttons["OK"].tap()

        // Verify the alert is dismissed
        XCTAssertFalse(downloadAlert.exists, "Download alert should be dismissed after tapping OK")
    }
}
