//
//  UserController.swift
//  App
//
//  Created by CaryZheng on 2018/4/11.
//

import Vapor
import FluentMySQL

class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let routes = router.grouped("users")
        routes.get(use: getAllUsers)
        routes.get(Int.parameter, use: getSpecifiedUser)
        routes.get("pagelist", use: getUserPageList)
        routes.post(use: createUser)
    }
    
    // Fetch all users
    func getAllUsers(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    // Fetch specified user
    func getSpecifiedUser(_ req: Request) throws -> Future<String> {
        let userId = try req.parameter(Int.self)
        return try User.query(on: req).filter(\.id == userId).first().map(to: String.self) { user in
            if user != nil {
                return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
            }
            
            return ResponseWrapper<DefaultResponseObj>(protocolCode: .failAccountNoExisted).makeResponse()
        }
    }

    // Fetch users by page
    func getUserPageList(_ req: Request) throws -> Future<[User]> {
        let pageSize = try? req.query.get(Int.self, at: "pageSize")
        let startPage = try? req.query.get(Int.self, at: "startPage")
        
        if let pageSize = pageSize, let startPage = startPage {
            let startIndex = startPage * pageSize
            let endIndex = startIndex + pageSize
            let queryRange: Range = startIndex..<endIndex
            return User.query(on: req).range(queryRange).all()
        }
        
        throw MyException.requestParamError
    }
    
    // Create new user
    func createUser(_ req: Request) throws -> Future<String> {
        let result = try req.content.decode(User.self).map(to: String.self) { user in
            _ = user.save(on: req)
            
            return ResponseWrapper(protocolCode: .success, obj: user).makeResponse()
        }
        
        return result
    }
    
}
