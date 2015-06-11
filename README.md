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


> Do you want to checkout [`Try`](https://github.com/nghialv/Try) µframework?
>
> [`Try`](https://github.com/nghialv/Try) is a µframework that provides Try&lt;T, Error> for dealing with try-catch in Swift 2.0.

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

```swift
let f = requestUser("nghialv") <^> { $0.id }

f.onSuccess { userId in
	println(userId)
}

```

- `flatMap` `>>-`

```swift
let f = searchRepositories("Hakuba") <^> { $0.first!.ownerName } >>- requestUser

f.onComplete { result in
	switch result {
		case .Success(let user):   println(user)
		case .Failure(let error):  println(error)
	}
}
```

- `filter`

``` swift
let e = NSError(domain: "noSuchElement", code: 1, userInfo: nil)
let f1 = searchRepositories("Hakuba")

let f = f1.filter(e){ $0.count > 0 } <^> { $0.first!.ownerName } >>- requestUser

f.onComplete { result in
	switch result {
		case .Success(let user):   println(user)
		case .Failure(let error):  println(error)
	}
}
```

- `andThen`

```swift
// side-effect
var reposCount = 0
        
let f1 = searchRepositories("Hakuba")
let f2 = f1.andThen { result in
    switch result {
        case .Success(let repos): reposCount = repos.value.count
        case .Failure(let error): break
    }
}
let f3 = f2 <^> { $0.first!.ownerName } >>- requestUser
        
f3.onComplete { result in
    switch result {
        case .Success(let user):   println(user)
        case .Failure(let error):  println(error)
    }
}
```

- `recover`

- `zip`

```swift
let f1 = searchRepositories("Future")
let f2 = requestUser("nghialv")
        
let f3 = f1.zip(f2)

f3.onSuccess { repos, user in
	println(repos)
	println(user)
}
```

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

