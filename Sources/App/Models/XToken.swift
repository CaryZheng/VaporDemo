import Vapor
import FluentProvider

final class XToken: Model {
    let storage = Storage()
    
    let token: String
    let userId: Identifier
    
    var user: Parent<XToken, User> {
        return parent(id: userId)
    }
    
    init(token: String, userId: Identifier) {
        self.token = token
        self.userId = userId
    }
    
    // read data from database
    init(row: Row) throws {
        token = try row.get("token")
        userId = try row.get("user_id")
    }
    
    // write data to database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("token", token)
        try row.set("user_id", userId)
        return row
    }
}

extension XToken: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("token")
            builder.string("user_id")
        }
    }
    
    static func revert(_ database: Database) throws {
//        try database.delete(self)
    }
}

extension XToken: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            token: json.get("token"),
            userId: json.get("user_id")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("token", token)
        try json.set("user_id", userId)
        return json
    }
}

extension XToken: ResponseRepresentable { }
