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
        
        // Check if login is required
        if app.buttons["loginButton"].exists {
            login() // Perform login only if needed
            
            // Confirm login success by checking for some element that indicates login is complete
            XCTAssertTrue(app.staticTexts["WelcomeMessage"].waitForExistence(timeout: 5), "Login failed or welcome message not displayed")
        }
        
        // Wait for the feed to load after login
        let feedCell = app.scrollViews.otherElements["FeedCell"]
        let exists = feedCell.waitForExistence(timeout: 10) // Increased timeout for feed loading
        XCTAssertTrue(exists, "Feed should load after login")
    }

    
    func testLikeButtonToggles() throws {
        login()
        
        // Assuming the app launches directly to the FeedView containing FeedCells
        let firstCell = app.scrollViews.otherElements["FeedCell"].firstMatch
        
        // Find the like button (heart icon)
        let likeButton = firstCell.buttons["heart"]
        XCTAssertTrue(likeButton.exists, "Like button should exist in FeedCell")
        
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
        login()
        
        let firstCell = app.scrollViews.otherElements["FeedCell"].firstMatch
        
        // Find the download button (arrow.down.to.line)
        let downloadButton = firstCell.buttons["arrow.down.to.line"]
        XCTAssertTrue(downloadButton.exists, "Download button should exist in FeedCell")
        
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
    
    
    
    func login() {
        // Simulate entering login details
        let emailTextField = app.textFields["emailTextField"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("user1@user1.com")
        
        let passwordSecureField = app.secureTextFields["passwordTextField"]
        XCTAssertTrue(passwordSecureField.exists)
        passwordSecureField.tap()
        passwordSecureField.typeText("user1@user1.com")
        
        let loginButton = app.buttons["loginButton"]
        loginButton.tap()
    }
}
