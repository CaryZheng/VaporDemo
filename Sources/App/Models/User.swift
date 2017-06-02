import Vapor
import FluentProvider
import AuthProvider

final class User: Model {
    let storage = Storage()
    
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    // read data from database
    init(row: Row) throws {
        name = try row.get("name")
        password = try row.get("password")
    }
    
    // write data to database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("password", password)
        return row
    }
}

extension User: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
//        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name"),
            password: json.get("password")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", name)
        try json.set("password", password)
        return json
    }
}

extension User: ResponseRepresentable { }

extension User: TokenAuthenticatable {
    // the token model that should be queried
    // to authenticate this user
    public typealias TokenType = XToken
}

extension Request {
    func user() throws -> User {
        let test: User = try auth.assertAuthenticated()
        return try auth.assertAuthenticated()
    }
}
