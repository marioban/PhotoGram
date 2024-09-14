//
//  LoginViewUITests.swift
//  InstagramUITests
//
//  Created by Mario Ban on 12.09.2024..
//

import XCTest

final class LoginViewUITests: XCTestCase {
    
    func testLoginScreenElementsExist() {
        let app = XCUIApplication()
        app.launch()
        
        func testLoginScreenElementsExist() {
            XCTContext.runActivity(named: "Checking Email TextField") { _ in
                let emailTextField = app.textFields["emailTextField"]
                XCTAssertTrue(emailTextField.waitForExistence(timeout: 5), "Email text field should exist")
            }

            XCTContext.runActivity(named: "Checking Password SecureField") { _ in
                let passwordSecureField = app.secureTextFields["passwordTextField"]
                XCTAssertTrue(passwordSecureField.waitForExistence(timeout: 5), "Password secure field should exist")
            }

            XCTContext.runActivity(named: "Checking Login Button") { _ in
                let loginButton = app.buttons["loginButton"]
                XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button should exist")
            }
        }

    }
}
