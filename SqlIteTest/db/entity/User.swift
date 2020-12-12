//
//  User.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/11/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import Foundation

class User {
    var id: Int = 0
    var name: String = ""
    var userName: String = ""
    var createdTime: String = ""
    
    
    init(id: Int, name: String, userName: String, createdTime: String) {
        self.id = id
        self.name = name
        self.userName = userName
        self.createdTime = createdTime
    }
}

class Item {
    var id: Int = 0
    var name: String = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct MyData: Decodable {
    var zone: [DataItem]!
}

struct DataItem: Decodable {
    var name: String!
    var url: String!
    var files: [ZoneFile]!
}

struct ZoneFile: Decodable {
    var url: String!
}
