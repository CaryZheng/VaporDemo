import Vapor
import FluentProvider

final class User: Model {
    let storage = Storage()
    
    var userId: Int
    var name: String
    var password: String
    
    init(id: Int, name: String, password: String) {
        self.userId = id
        self.name = name
        self.password = password
    }
    
    // read data from database
    init(row: Row) throws {
        userId = try row.get("id")
        name = try row.get("name")
        password = try row.get("password")
    }
    
    // write data to database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("id", userId)
        try row.set("name", name)
        try row.set("password", password)
        return row
    }
}

extension User: Preparation {

    static func prepare(_ database: Database) throws {
//        try database.create(self) { builder in
//            builder.id()
////            builder.int("id")
//            builder.string("name")
//            builder.string("password")
//        }
    }
    
    static func revert(_ database: Database) throws {
//        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            id: json.get("id"),
            name: json.get("name"),
            password: json.get("password")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", userId)
        try json.set("name", name)
        try json.set("password", password)
        return json
    }
}

extension User: ResponseRepresentable { }
