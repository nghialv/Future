//
//  Future.swift
//  Future
//
//  Created by Le Van Nghia on 5/31/15.
//  Copyright (c) 2015 Le Van Nghia. All rights reserved.
//

import Foundation
import Result

public class Future<T, Error> {
    public typealias ResultType = Result<T, Error>
    
    // MARK: Properties
    internal var result: Optional<ResultType>
    private let operation: (ResultType -> Void) -> Void
    
    public var value: Optional<T> {
        return result?.value
    }
    
    public var error: Optional<Error> {
        return result?.error
    }
    
    public var isCompleted: Bool {
        return result != nil
    }
    
    public var isSuccess: Bool {
        return result?.value != nil
    }
    
    public var isFailure: Bool {
        return result?.error != nil
    }
    
    // MAKR: Initilizers
    
    // Init a future with the given asynchronous operation.
    public init(operation: (ResultType -> Void) -> Void) {
        self.operation = operation
    }
    
    // Init a future with the given result (Result<T, Errror>).
    public convenience init(result: ResultType) {
        self.init(operation: { completion in
            completion(result)
        })
    }
    
    // Init a future that succeeded with the given `value`.
    public convenience init(value: T) {
        self.init(result: Result(value: value))
    }
    
    // Init a future that failed with the given `error`.
    public convenience init(error: Error) {
        self.init(result: Result(error: error))
    }
    
    
    // MARK - Completing
    
    // Completes the future with the given `completion` closure.
    // If the future is already completed, this will be applied immediately.
    public func onComplete(completion: ResultType -> Void) {
        if result != nil {
            completion(result!)
            return
        }
        self.operation { [weak self] result in
            self?.result = result
            completion(result)
        }
    }
    
    // Completes the future with `Success` completion.
    // If the future is already completed, this will be applied immediately.
    // And the `completion` closure is only executed if the future success.
    public func onSuccess(completion: T -> Void) {
        onComplete { result in
            switch result {
                case .Success(let bv): completion(bv.value)
                default: break
            }
        }
    }
    
    // Compeltes the future with `Failure` completion.
    // If the future is already completed, this will be applied immediately.
    // And the `completion` colosure is only executed if the future fails.
    public func onFailure(completion: Error -> Void) {
        onComplete { result in
            switch result {
                case .Failure(let be): completion(be.value)
                default: break
            }
        }
    }
}

// MARK: Funtional composition

extension Future {
    
    // map | you can also use `<^>` operator
    // Creates a new future by applying a function to the successful result of this future.
    // If this future is completed with an error then the new future will also contain this error.
    public func map<U>(f: T -> U) -> Future<U, Error> {
        return Future<U, Error>(operation: { completion in
            self.onComplete { result in
                switch result {
                    case .Success(let bv): completion(Result(value: f(bv.value)))
                    case .Failure(let be): completion(Result(error: be.value))
                }
            }
        })
    }
    
    // flatMap | | you can also use `>>-` operator
    // Creates a new future by applying a function to the successful result of this future, 
    // and returns the result of the function as the new future.
    // If this future is completed with an error then the new future will also contain this error.
    public func flatMap<U>(f: T -> Future<U, Error>) -> Future<U, Error> {
        return flatten(map(f))
    }
    
    // filter
    // Creates a new future by filtering the value of the current future with a predicate.
    // If the current future contains a value which satisfies the predicate, the new future will also hold that value.
    // Otherwise, the resulting future will fail with `noSuchElementError`.
    public func filter(noSuchElementError: Error, p: T -> Bool) -> Future<T, Error> {
        return Future<T, Error>(operation: { completion in
            self.onComplete { result in
                switch result {
                case .Success(let bv):
                    let r = p(bv.value) ? Result(value: bv.value) : Result(error: noSuchElementError)
                    completion(r)
                case .Failure: completion(result)
                }
            }
        })
    }
    
    // zip
    // Creates a new future that holds the tupple of results of `this` and `that`.
    public func zip<U>(that: Future<U, Error>) -> Future<(T,U), Error> {
        return self.flatMap { thisVal -> Future<(T,U), Error> in
            return that.map { thatVal in
                return (thisVal, thatVal)
            }
        }
    }
    
    // recover
    // Returns a future that succeeded if this is a success.
    // Returns a future that succeeded by applying function `f` to `error` value if this is a failure.
    public func recover(f: Error -> T) -> Future<T, Error> {
        return Future<T, Error>(operation: { completion in
            self.onComplete { result in
                switch result {
                case .Success: completion(result)
                case .Failure(let be): completion(Result(value: f(be.value)))
                }
            }
        })
    }
    
    // andThen
    // Applies the side-effect function to the result of this future.
    // and returns a new future with the result of this future.
    public func andThen(result: Result<T, Error> -> Void) -> Future<T, Error> {
        return Future<T, Error>(operation: { completion in
            self.onComplete { r in
                result(r)
                completion(r)
            }
        })
    }
}

// MARK: Funtions

// flatten
public func flatten<T, Error>(future: Future<Future<T, Error>, Error>) -> Future<T, Error> {
    return Future<T, Error>(operation: { completion in
        future.onComplete { result in
            switch result {
            case .Success(let bf): bf.value.onComplete(completion)
            case .Failure(let be): completion(Result(error: be.value))
            }
        }
    })
}

// MARK: Printable

extension Future: Printable {
    public var description: String {
        return "result: \(result)\n"
            + "isCompleted: \(isCompleted)\n"
            + "isSuccess: \(isSuccess)\n"
            + "isFailure: \(isFailure)\n"
    }
}


// MARK: DebugPrintable

extension Future: DebugPrintable {
    public var debugDescription: String {
        return description
    }
}


// MARK: Operators

infix operator <^> {
    // Left associativity
    associativity left

    // precedence
    precedence 150
}

/*
// Avoid conflict with the operator of Result
infix operator >>- {
    // Left associativity
    associativity left

    // Using the same `precedence` value in antitypical/Result
    precedence 100
}
*/

// Operator for `map`
public func <^> <T, U, Error> (future: Future<T, Error>, transform: T -> U) -> Future<U, Error> {
    return future.map(transform)
}

// Operator for `flatMap`
public func >>- <T, U, Error> (future: Future<T, Error>, transform: T -> Future<U, Error>) -> Future<U, Error> {
    return future.flatMap(transform)
}
