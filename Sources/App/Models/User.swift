//
//  User.swift
//  App
//
//  Created by CaryZheng on 2018/3/19.
//

import FluentMySQL
import Vapor

final class User: MySQLModel {
    var id: Int?
    var username: String
    var age: Int
    
    init(id: Int? = nil, username: String, age: Int) {
        self.id = id
        self.username = username
        self.age = age
    }
}

extension User: Content {}

extension User: Migration {}

extension User: Parameter {}
