Future
=====

[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/Future.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)]
(https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/nghialv/Future.svg?style=flat
)](https://github.com/nghialv/Future/issues?state=open)


Swift µframework providing Future&lt;T, Error>.

This library is inspired by the [talk of Javier Soto](https://realm.io/news/swift-summit-javier-soto-futures/) at SwiftSubmit2015 and the `Future` implementation in Scala.

And this is using `antitypical/Result`.

### Why we need Future?

##### Traditional async code

``` swift
 func requestRepository(repoId: Int64, completion: (Repository?, NSError?) -> Void) {}
 func requestUser(userId: Int64, completion: (User?, NSError?) -> Void) {}
 
 // get owner info of a given repository
 requestRepository(12345) { repo, error in
 	if let repo = repo {
 		requestUser(repo.ownerId) { user, error in
 		   if let user = user {
 		       // do something
 		   } else {
 		       // error handling
 		   }
 		}
 	} else {
 		// error handling
 	}
 }
 
```

##### Code with Future

``` swift
let future = requestRepository(12345)
		.map { $0.ownerId }
		.flatMap(requestUser)

future.onCompleted { result in
	switch result {
		case .Success(let user):   println(user)
		case .Failure(let error):  println(error)
	}
}

```

**Shorthand by using operator**

``` swift
let future = requestRepository(12345) <^> { $0.ownerId } >>- requestUser

future.onCompleted { result in
	switch result {
		case .Success(let user):   println(user)
		case .Failure(let error):  println(error)
	}
}
```

Usage
-----

- `map` `<^>`
- `flatMap` `>>-`
- `filter`
- `andThen`
- `recover`
- `zip`
- `flatten`


Installation
-----

- Using Carthage
>	- Insert `github "nghialv/Future"` to your Cartfile
>	- Run `carthage update`


- Using Cocoapods
>	- Insert `use_frameworks!` to your Podfile
>	- Insert `pod "Future"` to your Podfile
>	- Run `pod install`

- Using Submodule

Requirements
-----

- Swift 1.2 (Xcode 6.3 or later)
- iOS 8.0 or later

