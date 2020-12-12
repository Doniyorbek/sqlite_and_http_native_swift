//
//  Person.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/11/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import Foundation

class Person {
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id: Int, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}
