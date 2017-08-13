import Vapor
import HTTP

final class SignupController {

	func create(request: Request) throws -> ResponseRepresentable {
        
        let name = request.data["name"]?.string
        let password = request.data["password"]?.string
        
        if nil == name || nil == password {
            return ResponseWrapper(protocolCode: ProtocolCode.failParamError)
        }
        
        let queryResult = try User.makeQuery()
            .filter("name", .equals, name)
            .first()
        
        if nil != queryResult {
            return ResponseWrapper(protocolCode: ProtocolCode.failAccountHasExisted)
        }
        
        let hashPassword = try TokenHelper.createHashPassword(password!)
        try User(name: name!, password: hashPassword).save()
        
        return ResponseWrapper(protocolCode: ProtocolCode.success)
    }

}
