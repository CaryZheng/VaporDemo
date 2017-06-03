import Vapor
import AuthProvider

final class Routes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        builder.post("signup") { req in
            try SignupHelper.handleSignup(req: req)
        }
        
        builder.post("signin") { req in
            try SigninHelper.handleSignin(req: req)
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
