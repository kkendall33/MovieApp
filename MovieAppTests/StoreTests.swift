//
//  StoreTests.swift
//  MovieAppTests
//
//  Created by Kyle Kendall on 3/27/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import XCTest
@testable import MovieApp

class StoreTests: XCTestCase {
    
    func testInvalidContainerName() {
        var thrownError: Error?
        do {
            _ = try Store(containerName: "someRandomNameThatIsInvalid")
        } catch {
            thrownError = error
        }
        
        XCTAssert(thrownError == nil, "Should have gotten an error with an invalid container name.")
    }
    
}
