import HTTP

final class SignupHelper {
    
    static func handleSignup(req: Request) throws -> ResponseRepresentable {
        let name = req.data["name"]?.string
        let password = req.data["password"]?.string
        
        if nil == name || nil == password {
            return ResponseWrapper(protocolCode: ProtocolCode.FailParamError)
        }
        
        let queryResult = try User.makeQuery()
            .filter("name", .equals, name)
            .first()
        
        if nil != queryResult {
            return ResponseWrapper(protocolCode: ProtocolCode.FailAccountHasExisted)
        }
        
        try User(name: name!, password: password!).save()
        
        return ResponseWrapper(protocolCode: ProtocolCode.Success)
    }
    
}
