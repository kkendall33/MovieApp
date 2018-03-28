//
//  IntExtensionTests.swift
//  MovieAppTests
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import XCTest
@testable import MovieApp

class IntExtensionTests: XCTestCase {
    
    func testIntExtension() {
        let value = 1.stringValue
        XCTAssert(value == "1", "1 should be 1")
        
        let value1 = 123456789.stringValue
        XCTAssert(value1 == "123456789", "123456789 should be 123456789")
        
        let value2 = (-1).stringValue
        XCTAssert(value2 == "-1", "-1 should be -1")
    }
    
}
