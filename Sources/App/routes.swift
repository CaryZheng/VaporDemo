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
    
    try router.register(collection: UserController())
    try router.register(collection: CryptoController())
}

