import Routing
import Vapor
import FluentMySQL

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("test") { req -> String in
        struct TestUser: Codable {
            var name: String
            var age: Int
            var score: Int
        }
        
        let user = TestUser(name: "gg", age: 18, score: 88)
        let response = ResponseWrapper<TestUser>(protocolCode: .failSignIn, obj: user).makeResponse()
        
        return response
    }
    
    router.get("users") { req -> Future<[User]> in
        let allUsers = User.query(on: req).all()
        
        return allUsers
    }
    
    router.get("users", Int.parameter) { req -> Future<String> in
        let userId = try req.parameter(Int.self)
        return try User.query(on: req).filter(\.id == userId).first().map(to: String.self) { user in
            if user != nil {
                return "The account is existed"
            }
            
            return "The account is not existed"
        }
    }
    
    router.post("user") { req -> Future<String> in
        let result = try req.content.decode(User.self).map(to: String.self) { user in
            _ = user.save(on: req)
            
            return "create user success"
        }
        
        return result
    }
    
    // Example of creating a Service and using it.
    router.get("hash", String.parameter) { req -> String in
        // Create a BCryptHasher using the Request's Container
        let hasher = try req.make(BCryptHasher.self)

        // Fetch the String parameter (as described in the route)
        let string = try req.parameter(String.self)

        // Return the hashed string!
        return try hasher.make(string)
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

