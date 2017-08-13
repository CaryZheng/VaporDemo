import Vapor
import HTTP

final class UserController: ResourceRepresentable {

	func index(request: Request) throws -> ResponseRepresentable {
        
        try CheckHelper.checkTokenValid(request: request)
        
        let xtoken = RequestHelper.getXToken(request: request)!
        
        let userId = try TokenHelper.parseXToken(xtoken)
        let cacheXToken = try DropletHelper.getDroplet().cache.get(userId)
        if cacheXToken?.string == xtoken {
            
            let result = try User.makeQuery()
                .filter("id", .equals, userId)
                .first()
            
            if nil == result {
                return ResponseWrapper(protocolCode: ProtocolCode.failInternalError)
            }
            
            var json = JSON()
            try json.set("id", result?.id)
            try json.set("name", result?.name)
            
            return ResponseWrapper(protocolCode: .success, obj: json)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.failTokenInvalid)
    }

	func makeResource() -> Resource<User> {
        return Resource(
            index: index
        )
    }

}

extension UserController: EmptyInitializable { }
