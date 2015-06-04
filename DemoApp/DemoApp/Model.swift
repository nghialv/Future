//
//  Model.swift
//  DemoApp
//
//  Created by Le VanNghia on 6/4/15.
//  Copyright (c) 2015 Le Van Nghia. All rights reserved.
//

import Foundation
import Himotoki

struct Repository: Decodable, Printable {
    let id          : Int64
    let name        : String
    let url         : String
    let ownerName   : String
    
    static func decode(e: Extractor) -> Repository? {
        let create = { Repository($0) }
        
        return build(
            e <| "id",
            e <| "name",
            e <| "url",
            e <| "owner.login"
            ).map(create)
    }
    
    var description: String {
        return  "id : \(id)\n" +
            "name: \(name)\n" +
            "url: \(url)\n" +
            "ownerName: \(ownerName)"
    }
}

struct User: Decodable, Printable {
    let id          : Int64
    let login       : String
    let url         : String
    
    static func decode(e: Extractor) -> User? {
        let create = { User($0) }
        
        return build(
            e <| "id",
            e <| "login",
            e <| "url"
            ).map(create)
    }
    
    var description: String {
        return "id: \(id)\n" +
            "login: \(login)\n" +
            "url: \(url)\n"
    }
}