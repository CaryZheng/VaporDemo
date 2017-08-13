import Vapor
import AuthProvider

final class Routes: RouteCollection {
    
    let view: ViewRenderer
    
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        builder.get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
         builder.get("leafimage") { req in
             return try self.view.make("welcome")
         }

        builder.get("leaftext") { req in
            return try self.view.make("hello", [
                    "name": "Cary"
                ])
        }

        builder.get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        
//        try builder.resource("posts", PostController.self)
        try builder.resource("user", UserController.self)
        
        let signinVC = SigninController()
        builder.post("signin", handler: signinVC.create)
        
        let signupVC = SignupController()
        builder.post("signup", handler: signupVC.create)
    }
}

/// Since Routes doesn't depend on anything
/// to be initialized, we can conform it to EmptyInitializable
///
/// This will allow it to be passed by type.
//extension Routes: EmptyInitializable { }
