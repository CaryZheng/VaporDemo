import Vapor

/// Register your application's routes here.
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
    
    router.get("protobuf") { req -> String in
        var info = BookInfo()
        info.id = 1098
        info.title = "Zzb Test"
        info.author = "CaryZheng"
        
        let binaryData: Data = try info.serializedData()
        let decodedInfo = try BookInfo(serializedData: binaryData)
        
        print("protobuf decodedInfo = \(decodedInfo)")
        
        let jsonData: Data = try info.jsonUTF8Data()
        let receiveFromJSON = try BookInfo(jsonUTF8Data: jsonData)
        
        print("protobuf receiveFromJSON = \(receiveFromJSON)")
        
        return ResponseWrapper<DefaultResponseObj>(protocolCode: .success).makeResponse()
    }
    
    try router.register(collection: UserController())
    try router.register(collection: CryptoController())
    try router.register(collection: HttpController())
}

