//
//  TimestampUnitTests.swift
//  InstagramUnitTests
//
//  Created by Mario Ban on 03.09.2024..
//

@testable import Instagram
import XCTest
import Firebase

final class TimestampUnitTests: XCTestCase {
    
    func testTimestampStringJustNow() {
        // Given a timestamp that is a few seconds ago
        let now = Date()
        let timestamp = Timestamp(date: now.addingTimeInterval(-5))
        
        // When converting to string
        let result = timestamp.timestampString()
        
        // Then it should be "5s" or similar
        XCTAssertTrue(result.contains("s"), "Expected result to contain 's' for seconds, but got \(result)")
    }
    
    func testTimestampStringMinutesAgo() {
           // Given a timestamp that is 5 minutes ago
           let now = Date()
           let timestamp = Timestamp(date: now.addingTimeInterval(-300)) // 5 * 60 seconds
           
           // When converting to string
           let result = timestamp.timestampString()
           
           // Then it should be "5m" or similar
           XCTAssertTrue(result.contains("m"), "Expected result to contain 'm' for minutes, but got \(result)")
       }
       
       func testTimestampStringHoursAgo() {
           // Given a timestamp that is 2 hours ago
           let now = Date()
           let timestamp = Timestamp(date: now.addingTimeInterval(-7200)) // 2 * 60 * 60 seconds
           
           // When converting to string
           let result = timestamp.timestampString()
           
           // Then it should be "2h" or similar
           XCTAssertTrue(result.contains("h"), "Expected result to contain 'h' for hours, but got \(result)")
       }
       
       func testTimestampStringDaysAgo() {
           // Given a timestamp that is 3 days ago
           let now = Date()
           let timestamp = Timestamp(date: now.addingTimeInterval(-259200)) // 3 * 24 * 60 * 60 seconds
           
           // When converting to string
           let result = timestamp.timestampString()
           
           // Then it should be "3d" or similar
           XCTAssertTrue(result.contains("d"), "Expected result to contain 'd' for days, but got \(result)")
       }
       
       func testTimestampStringWeeksAgo() {
           // Given a timestamp that is 2 weeks ago
           let now = Date()
           let timestamp = Timestamp(date: now.addingTimeInterval(-1209600)) // 2 * 7 * 24 * 60 * 60 seconds
           
           // When converting to string
           let result = timestamp.timestampString()
           
           // Then it should be "2w" or similar
           XCTAssertTrue(result.contains("w"), "Expected result to contain 'w' for weeks, but got \(result)")
       }

}
