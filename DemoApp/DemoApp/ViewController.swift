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
        
        let f = searchRepositories("Hakuba") <^> { $0[0].ownerName } >>- requestUser
        f.onSuccess { result in
            println(result)
        }
    }
}
