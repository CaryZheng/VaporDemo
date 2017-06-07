import Vapor
import HTTP

final class UserController: ResourceRepresentable {

	func index(request: Request) throws -> ResponseRepresentable {
        
        let xtoken = request.headers["XToken"]?.string
        if nil == xtoken {
            return ResponseWrapper(protocolCode: ProtocolCode.FailTokenInvalid)
        }
        
        let userId = try TokenHelper.parseXToken(xtoken!)
        let cacheXToken = try DropletHelper.getDroplet().cache.get(userId)
        if cacheXToken?.string == xtoken {
            
            let result = try User.makeQuery()
                .filter("id", .equals, userId)
                .first()
            
            if nil == result {
                return ResponseWrapper(protocolCode: ProtocolCode.FailInternalError)
            }
            
            var json = JSON()
            try json.set("id", result?.id)
            try json.set("name", result?.name)
            
            return ResponseWrapper(protocolCode: .Success, obj: json)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.FailTokenInvalid)
    }

	func makeResource() -> Resource<User> {
        return Resource(
            index: index
        )
    }

}

extension UserController: EmptyInitializable { }
