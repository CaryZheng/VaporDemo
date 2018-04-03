import Routing
import Vapor
import FluentMySQL
import Crypto

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
    
    // Fetch all users
    router.get("users") { req -> Future<[User]> in
        return User.query(on: req).all()
    }
    
    // Fetch specified user
    router.get("users", Int.parameter) { req -> Future<String> in
        let userId = try req.parameter(Int.self)
        return try User.query(on: req).filter(\.id == userId).first().map(to: String.self) { user in
            if user != nil {
                return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
            }
            
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeResponse()
        }
    }
    
    // Create new user
    router.post("user") { req -> Future<String> in
        let result = try req.content.decode(User.self).map(to: String.self) { user in
            _ = user.save(on: req)
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
        
        return result
    }
    
    // Hash
    router.get("crypto", "hash", String.parameter) { req -> String in
        let value = try req.parameter(String.self)
        let hashData = try SHA1.hash(value)
        
        let result = hashData.hexEncodedString()
        
        return ResponseWrapper(protocolCode: .success, obj: result).makeResponse()
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

