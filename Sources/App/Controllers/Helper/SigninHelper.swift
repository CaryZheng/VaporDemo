import HTTP
import Cache
import Foundation

final class SigninHelper {
    
    static func handleSignin(req: Request) throws -> ResponseRepresentable {
        let name = req.data["name"]?.string
        let password = req.data["password"]?.string
        
        if nil == name || nil == password {
            return ResponseWrapper(protocolCode: ProtocolCode.FailParamError)
        }
        
        let hashPassword = try TokenHelper.createHashPassword(password!)
        let result = try User.makeQuery()
            .filter("name", .equals, name)
            .filter("password", .equals, hashPassword)
            .first()
        
        if nil != result {
            let xtoken = try TokenHelper.createXToken(account: result!.name)
            
            try DropletHelper.getDroplet().cache.set(result!.name, xtoken)
            
            return try ResponseWrapper(protocolCode: ProtocolCode.Success).makeResponse(xtoken: xtoken)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.FailSignIn)
    }
    
}
