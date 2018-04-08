import Routing
import Vapor
import FluentMySQL
import Crypto
import Random

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    // log
    router.get("log") { req -> String in
        let logger = try req.make(Logger.self)
        logger.info("log: info")
        logger.debug("log: debug")
        logger.error("log: error")
        logger.fatal("log: fatal")
        logger.verbose("log: verbose")
        logger.warning("log: warning")
        
        return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
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
    
    // Fetch users by page
    router.get("users", "pagelist") { req -> Future<[User]> in
        let pageSize = try? req.query.get(Int.self, at: "pageSize")
        let startPage = try? req.query.get(Int.self, at: "startPage")
        
        if let pageSize = pageSize, let startPage = startPage {
            let startIndex = startPage * pageSize
            let endIndex = startIndex + pageSize
            let queryRange: Range = startIndex..<endIndex
            return User.query(on: req).range(queryRange).all()
        }
        
        throw MyException.requestParamError
    }
    
    // Create new user
    router.post("users") { req -> Future<String> in
        let result = try req.content.decode(User.self).map(to: String.self) { user in
            _ = user.save(on: req)
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
        
        return result
    }
    
    // crypto
    router.group("crypto") { group in
        // Hash
        group.get("hash", String.parameter) { req -> String in
            let value = try req.parameter(String.self)
            
            let hashData = try SHA1.hash(value)
            let result = hashData.hexEncodedString()
            
            return ResponseWrapper(protocolCode: .success, obj: result).makeResponse()
        }
        
        // AES128
        group.get("aes128", String.parameter) { req -> String in
            let value = try req.parameter(String.self)
            
            let key = "qwertgfdsa123490"
            
            let ciphertext = try AES128.encrypt(value, key: key)
            let originalData = try AES128.decrypt(ciphertext, key: key)
            
            let result = String(data: originalData, encoding: .utf8)!
            
            return ResponseWrapper(protocolCode: .success, obj: result).makeResponse()
        }
        
        // Random
        group.get("random") { req -> String in            
            let randomInt = try OSRandom().generate(UInt8.self) % 100
            
            return ResponseWrapper(protocolCode: .success, obj: randomInt).makeResponse()
        }
    }
    
    // HTTP
    router.group("http") { group in
        // Get
        group.get("get") { req -> Future<String> in
            let hostname = "httpbin.org"
            let port = 80
            let path = "/anything"
            
            let loop = req.eventLoop
            return HTTPClient.connect(hostname: hostname, port: port, on: loop).flatMap(to: HTTPResponse.self) { client in
                var req = HTTPRequest(method: .GET, url: URL(string: path)!)
                req.headers.replaceOrAdd(name: .host, value: hostname)
                req.headers.replaceOrAdd(name: .userAgent, value: "vapor/engine")
                return client.respond(to: req, on: loop)
            }.map(to: String.self) { res in
                return String(data: res.body.data ?? Data(), encoding: .ascii)!
            }
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

