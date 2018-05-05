//
//  MyMiddleware.swift
//  App
//
//  Created by CaryZheng on 2018/4/2.
//

import Vapor
import Validation

class MyMiddleware: Middleware, Service {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        
        let promise = request.eventLoop.newPromise(Response.self)
        
        func handleError(_ error: Swift.Error) {
            let res = request.makeResponse()
            
            res.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
            
            let reason: String = error.localizedDescription
            
            var protocolCode = ProtocolCode.failInternalError
            if error is ValidationError
                || error is MyException {
                protocolCode = ProtocolCode.failParamError
            }
            
            let bodyStr = ResponseWrapper<DefaultResponseObj>(protocolCode: protocolCode, msg: reason).makeResponse()
            res.http.body = HTTPBody(string: bodyStr)
            
            promise.succeed(result: res)
        }
        
        do {
            try next.respond(to: request).do { res in
                
                res.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
                
                promise.succeed(result: res)
            }.catch { error in
                handleError(error)
            }
        } catch {
            handleError(error)
        }
        
        return promise.futureResult
    }
    
}
