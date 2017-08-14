import Vapor

class V1Collection: RouteCollection {

    let view: ViewRenderer
    
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        let v1 = builder.grouped("v1")
        buildLeaf(v1)
        try buildUser(v1)
    }
    
    fileprivate func buildLeaf(_ builder: RouteBuilder) {
        let leaf = builder.grouped("leaf")
        
        leaf.get("text") { req in
            return try self.view.make("hello", [
                "name": "Cary"
                ])
        }
        
        leaf.get("image") { req in
            return try self.view.make("welcome")
        }

        let myMarkdown = "# Hey #\nCheck out my *awesome* markdown! It is easy to use in `tags`"
        leaf.get("markdown") { req in
            return try self.view.make("markdown", [
                "myMarkdown": myMarkdown
                ])
        }
    }
    
    fileprivate func buildUser(_ builder: RouteBuilder) throws {
        try builder.resource("user", UserController.self)
        
        let userRoute = "user"
        
        let signinVC = SigninController()
        builder.post(userRoute+"/signin", handler: signinVC.create)
        
        let signupVC = SignupController()
        builder.post(userRoute+"/signup", handler: signupVC.create)
    }
    
}
