import Routing
import Vapor

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
    
    try router.register(collection: UserController())
    try router.register(collection: CryptoController())
    try router.register(collection: HttpController())
}

