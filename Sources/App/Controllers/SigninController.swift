import Vapor
import HTTP

final class SigninController {
    
    func create(request: Request) throws -> ResponseRepresentable {
        
        let name = request.data["name"]?.string
        let password = request.data["password"]?.string
        
        if nil == name || nil == password {
            return ResponseWrapper(protocolCode: ProtocolCode.FailParamError)
        }
        
        let hashPassword = try TokenHelper.createHashPassword(password!)
        let result = try User.makeQuery()
            .filter("name", .equals, name)
            .filter("password", .equals, hashPassword)
            .first()
        
        if nil != result {
            let xtoken = try TokenHelper.createXToken(userId: "\((result!.id?.int)!)")
            
            let userId = result?.id?.int
            if nil == userId {
                return ResponseWrapper(protocolCode: ProtocolCode.FailInternalError)
            }
            
            try DropletHelper.getDroplet().cache.set("\(userId!)", xtoken)
            
            return try ResponseWrapper(protocolCode: ProtocolCode.Success).makeResponse(xtoken: xtoken)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.FailSignIn)
    }
    
}
