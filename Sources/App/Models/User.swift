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

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content {}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration {}

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter {}
