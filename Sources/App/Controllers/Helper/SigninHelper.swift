import HTTP

final class SigninHelper {
    
    static func handleSignin(req: Request) throws -> ResponseRepresentable {
        let name = req.data["name"]?.string
        let password = req.data["password"]?.string
        
        if nil == name || nil == password {
            return ResponseWrapper(protocolCode: ProtocolCode.FailParamError)
        }
        
        let hashPassword = try TokenHelper.createToken(password!)
        let result = try User.makeQuery()
            .filter("name", .equals, name)
            .filter("password", .equals, hashPassword)
            .first()
        
        if nil != result {
            return ResponseWrapper(protocolCode: ProtocolCode.Success)
        }
        
        return ResponseWrapper(protocolCode: ProtocolCode.FailSignIn)
    }
    
}
