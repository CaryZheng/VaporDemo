import Vapor
import HTTP

final class SigninController {
    
    func handleSignin(req: Request) throws -> ResponseRepresentable {
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
    
}
