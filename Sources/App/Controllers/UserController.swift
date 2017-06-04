import Vapor
import HTTP

final class UserController: ResourceRepresentable {

	func index(request: Request) throws -> ResponseRepresentable {
        
        let name = "zzb"
        let xtoken = request.headers["XToken"]?.string
        
        let cacheXToken = try DropletHelper.getDroplet().cache.get(name)
        if nil != xtoken && cacheXToken?.string == xtoken {
            let result = try TokenHelper.parseXToken(xtoken!)
            
            var json = JSON()
            try json.set("name", result)
            
            return ResponseWrapper(protocolCode: .Success, obj: json)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.FailInternalError)
    }

	func makeResource() -> Resource<User> {
        return Resource(
            index: index
        )
    }

}

extension UserController: EmptyInitializable { }
