import Vapor
import AuthProvider

final class Routes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        builder.post("signin") { req in
            
            let name = req.data["name"]?.string
            let password = req.data["password"]?.string
            
            if nil == name || nil == password {
                return ResponseWrapper(protocolCode: ProtocolCode.FailParamError)
            }
            
            let result = try User.makeQuery()
                .filter("name", .equals, name)
                .filter("password", .equals, password)
                .first()
            
            if nil != result {
                return ResponseWrapper(protocolCode: ProtocolCode.Success)
            }
            
            return ResponseWrapper(protocolCode: ProtocolCode.FailSignIn)
        }
        
        builder.get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        builder.get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }

        builder.get("*") { req in return req.description }
        
//        try builder.resource("posts", PostController.self)
        try builder.resource("user", UserController.self)
        
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        builder.group(tokenMiddleware, handler: { authorized in
            authorized.get("me") { req in
                // return the authenticated user's name
                return try req.user().name
            }
        })
    }
}

/// Since Routes doesn't depend on anything
/// to be initialized, we can conform it to EmptyInitializable
///
/// This will allow it to be passed by type.
extension Routes: EmptyInitializable { }
