//
//  MyMiddleware.swift
//  App
//
//  Created by CaryZheng on 2018/4/2.
//

import Vapor

class MyMiddleware: Middleware, Service {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        
        return try next.respond(to: request).map { response in
            response.http.headers.replaceOrAdd(name: .contentType, value: "application/json")
            
            return response
        }
    }
    
}
