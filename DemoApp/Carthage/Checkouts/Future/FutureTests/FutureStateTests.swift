//
//  FutureStateTests.swift
//  FutureStateTests
//
//  Created by Le VanNghia on 5/31/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import UIKit
import XCTest
import Result
import Future

class FutureStateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

// MAKR: Test future state

extension FutureStateTests {
    func testFutureStateBeforeCompleting() {
        let f1 = Future<Int, NSError>(value: 1)
        let f2 = Future<Int, NSError>(error: NSError(domain: "Failed", code: 1, userInfo: nil))
        let f3 = Future<Int, NSError> { completion in
            delay(2) {
                completion(Result(value: 1))
            }
        }
        let futures = [f1, f2, f3]
        for f in futures {
            checkFutureShouldNotBeCompleted(f)
            XCTAssertNil(f.value, "Future should return nil value")
            XCTAssertNil(f.error, "Future should return nil error")
        }
    }
    
    func testFutureStateAfterCompletingForSucceededFuture() {
        let f = Future<Int, NSError>(value: 1)
        f.onComplete { result in
            switch result {
            case .Success(let bv): XCTAssertEqual(bv.value, 1, "Future should return 1 in success result")
            case .Failure: XCTAssertFalse(true, "Future should complete with success result")
            }
        }
       
        checkFutureShouldCompletedWithValue(f)
        XCTAssertNotNil(f.value, "Future should return a value")
        XCTAssertNil(f.error, "Future should return nil error")
    }
    
    func testFutureStateAfterCompletingForFailedFuture() {
        let error = NSError(domain: "Failed", code: 1, userInfo: nil)
        let f = Future<Int, NSError>(error: error)
        f.onComplete { result in
            switch result {
                case .Success: XCTAssertFalse(true, "Future should complete with failure result")
                case .Failure(let be): XCTAssertEqual(be.value, error, "Future should return 1 in success result")
            }
        }
       
        checkFutureShouldCompletedWithError(f)
        XCTAssertNil(f.value, "Future should return nil value")
        XCTAssertNotNil(f.error, "Future should return an error")
    }
    
    func testFutureStateAfterCompletingForAsyncFuture() {
        let f = Future<Int, NSError> { completion in
            delay(3) {
                completion(Result(value: 1))
            }
        }
        let expectation = expectationWithDescription("Future completed")
        
        f.onComplete { result in
            switch result {
            case .Success(let bv): XCTAssertEqual(bv.value, 1, "Future should return 1 in success result")
            case .Failure: XCTAssertFalse(true, "Future should complete with success result")
            }
            expectation.fulfill()
        }
       
        checkFutureShouldNotBeCompleted(f)
        XCTAssertNil(f.value, "Future should return nil value")
        XCTAssertNil(f.error, "Future should return nil error")
        
        waitForExpectationsWithTimeout(3.5) { _ in
            checkFutureShouldCompletedWithValue(f)
            XCTAssertEqual(f.value!, 1, "Future should return 1")
            XCTAssertNil(f.error, "Future should return nil error")
        }
    }
}
