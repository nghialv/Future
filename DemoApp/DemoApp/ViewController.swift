//
//  ViewController.swift
//  DemoApp
//
//  Created by Le VanNghia on 6/4/15.
//  Copyright (c) 2015 Le Van Nghia. All rights reserved.
//

import UIKit
import Result
import Future

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let e = NSError(domain: "noSuchElement", code: 1, userInfo: nil)
        
        let f = searchRepositories("Hakuba").filter(e){ $0.count > 0 } <^> { $0.first!.ownerName } >>- requestUser
        f.onComplete { result in
            switch result {
            case .Success(let user):   println(user)
            case .Failure(let error):  println(error)
            }
        }
    }
}
