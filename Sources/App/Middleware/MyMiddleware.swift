import HTTP

class MyMiddleware: Middleware {

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        var response: Response? = nil
        
        do {
            response = try next.respond(to: request)
        } catch MyException.tokenInvalid {
            return try ResponseWrapper(protocolCode: ProtocolCode.failTokenInvalid).makeResponse()
        }
        
        if nil == response {
            response = try ResponseWrapper(protocolCode: ProtocolCode.unknown).makeResponse()
        }
        
        return response!
    }
    
}
