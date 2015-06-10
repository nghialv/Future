//
//  TestUtils.swift
//  Future
//
//  Created by Le VanNghia on 6/1/15.
//  Copyright (c) 2015 Le VanNghia. All rights reserved.
//

import Foundation
import XCTest
import Future
import Result

func requestString(string: String) -> Future<String, NSError> {
    return Future<String, NSError> { completion in
        delay(1) {
            completion(Result(value: string))
        }
    }
}


func requestStringReturnError(string: String) -> Future<String, NSError> {
    return Future<String, NSError> { completion in
        delay(1) {
            let error = NSError(domain: string, code: 1, userInfo: nil)
            completion(Result(error: error))
        }
    }
}


func requestStringFromNumber(number: Int) -> Future<String, NSError> {
    return Future<String, NSError> { completion in
        delay(1) {
            completion(Result(value: "\(number)"))
        }
    }
}

func requestStringLenght(string: String) -> Future<Int, NSError> {
    return Future<Int, NSError> { completion in
        delay(1) {
            completion(Result(value: count(string)))
        }
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func checkFutureShouldCompletedWithValue<T, Error>(f: Future<T, Error>) {
    XCTAssertTrue(f.isCompleted, "Future should be Completed")
    XCTAssertTrue(f.isSuccess, "Future should be Success")
    XCTAssertFalse(f.isFailure, "Future should not be Failure")
}

func checkFutureShouldCompletedWithError<T, Error>(f: Future<T, Error>) {
    XCTAssertTrue(f.isCompleted, "Future should be Completed")
    XCTAssertFalse(f.isSuccess, "Future should not be Success")
    XCTAssertTrue(f.isFailure, "Future should be Failure")
}

func checkFutureShouldNotBeCompleted<T, Error>(f: Future<T, Error>) {
    XCTAssertFalse(f.isCompleted, "Future should not be Completed")
    XCTAssertFalse(f.isSuccess, "Future should not be Success")
    XCTAssertFalse(f.isFailure, "Future should not be Failure")
}
