//
//  PathTests.swift
//  MovieAppTests
//
//  Created by Kyle Kendall on 3/28/18.
//  Copyright © 2018 Kyle Kendall. All rights reserved.
//

import XCTest
@testable import MovieApp

class PathTests: XCTestCase {
    
    func testInvalidPathArgument() {
        var thrownError: Path.PathError?
        do {
            _ = try Path(originalPath: "the/path/with/no/arguments", pathArguments: [Path.Argument(key: "Uh", value: "Dude")])
        } catch {
            thrownError = error as? Path.PathError
        }
        XCTAssert(thrownError == Path.PathError.invalidPathArgument, "Should have gotten an error here")
    }
    
    func testInvalidPath() {
        var thrownError: Path.PathError?
        do {
            _ = try Path(originalPath: "", pathArguments: [Path.Argument(key: "Uh", value: "Dude")])
        } catch {
            thrownError = error as? Path.PathError
        }
        XCTAssert(thrownError == Path.PathError.invalidOriginalPath, "Should have gotten an error here")
    }
    
    func testValidPathWithNoArguments() {
        do {
            let original = "some/path"
            let path = try Path(originalPath: original, pathArguments: [])
            XCTAssert(path.path == original, "\(path.path) should be \(original)")
        } catch {
            XCTAssert(false, "Should not have gotten an error here")
        }
    }
    
    func testValidPathWithOneArgumentAtEnd() {
        do {
            let key = "test"
            let value = "value"
            let original = "some/path/{\(key)}"
            let argument = Path.Argument(key: key, value: value)
            let path = try Path(originalPath: original, pathArguments: [argument])
            XCTAssert(path.path == "some/path/\(value)", "\(path.path) should be some/path/\(value)")
        } catch {
            XCTAssert(false, "Should not have gotten an error here")
        }
    }
    
    func testValidPathWithOneArgumentAtStart() {
        do {
            let key = "test"
            let value = "value"
            let original = "{\(key)}/some/path"
            let argument = Path.Argument(key: key, value: value)
            let path = try Path(originalPath: original, pathArguments: [argument])
            XCTAssert(path.path == "\(value)/some/path", "\(path.path) should be \(value)/some/path")
        } catch {
            XCTAssert(false, "Should not have gotten an error here")
        }
    }
    
    func testValidPathWithOneArgumentInMiddle() {
        do {
            let key = "test"
            let value = "value"
            let original = "some/{\(key)}/path"
            let argument = Path.Argument(key: key, value: value)
            let path = try Path(originalPath: original, pathArguments: [argument])
            XCTAssert(path.path == "some/\(value)/path", "\(path.path) should be some/\(value)/path")
        } catch {
            XCTAssert(false, "Should not have gotten an error here")
        }
    }
    
    func testValidPathWithMultipleArguments() {
        do {
            let original = "some/path/{first}/{second}"
            let argument1 = Path.Argument(key: "first", value: "firstValue")
            let argument2 = Path.Argument(key: "second", value: "secondValue")
            let path = try Path(originalPath: original, pathArguments: [argument1, argument2])
            XCTAssert(path.path == "some/path/firstValue/secondValue", "\(path.path) should be some/path/firstValue/secondValue")
        } catch {
            XCTAssert(false, "Should not have gotten an error here")
        }
    }
    
}
