//
//  Api.swift
//  DemoApp
//
//  Created by Le VanNghia on 6/4/15.
//  Copyright (c) 2015 Le Van Nghia. All rights reserved.
//

import Foundation
import Alamofire
import Result
import Future
import Himotoki

func requestUser(username: String) -> Future<User, NSError> {
    return Future { completion in
        let urlString = "https://api.github.com/users/\(username)"
        
        Alamofire.request(.GET, urlString)
            .responseJSON { _, _, json, error in
                let result: Result<User, NSError>
                if let error = error {
                    result = Result(error: error)
                } else {
                    let u: User? = decode(json!)
                    result = Result(value: u!)
                }
                
                completion(result)
        }
    }
}

func searchRepositories(keyword: String) -> Future<[Repository], NSError> {
    return Future { completion in
        let urlString = "https://api.github.com/search/repositories?q=\(keyword)+language:swift&sort=stars&order=desc"
        
        Alamofire.request(.GET, urlString)
            .responseJSON { _, _, json, error in
                let itemsJson: AnyObject? = (json as! [String: AnyObject])["items"]
                let repos: [Repository]? = decode(itemsJson!)
                let result: Result<[Repository], NSError>
                
                if let error = error {
                    result = Result(error: error)
                } else {
                    result = Result(value: repos ?? [])
                }
                completion(result)
        }
    }
}