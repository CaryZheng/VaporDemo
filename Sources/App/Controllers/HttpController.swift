//
//  HttpController.swift
//  App
//
//  Created by CaryZheng on 2018/4/11.
//

import Vapor

class HttpController: RouteCollection {
    
    func boot(router: Router) throws {
        let routes = router.grouped("http")
        routes.get("get", use: get)
    }
    
    // Get
    func get(_ req: Request) throws -> Future<String> {
        let hostname = "httpbin.org"
        let port = 80
        let path = "/ip"
        
        let loop = req.eventLoop
        return HTTPClient.connect(hostname: hostname, port: port, on: loop).flatMap(to: HTTPResponse.self) { client in
            let req = HTTPRequest(method: .GET, url: URL(string: path)!)
            return client.send(req)
            }.map(to: String.self) { res in
                return String(data: res.body.data ?? Data(), encoding: .ascii)!
        }
    }
    
}
