import Vapor
import HTTP

final class UserController: ResourceRepresentable {

	func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeJSON()
    }

	func makeResource() -> Resource<User> {
        return Resource(
            index: index
        )
    }

}

extension UserController: EmptyInitializable { }
