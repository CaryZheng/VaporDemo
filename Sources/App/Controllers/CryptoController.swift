//
//  CryptoController.swift
//  App
//
//  Created by CaryZheng on 2018/4/11.
//

import Vapor
import Crypto
import Random

class CryptoController: RouteCollection {
    
    func boot(router: Router) throws {
        let routes = router.grouped("crypto")
        routes.get(use: hash)
        routes.get("hash", String.parameter, use: hash)
        routes.get("aes128", String.parameter, use: aes128)
        routes.get("random", use: random)
    }
    
    // hash
    func hash(_ req: Request) throws -> String {
        let value = try req.parameter(String.self)
        
        let hashData = try SHA1.hash(value)
        let result = hashData.hexEncodedString()
        
        return ResponseWrapper(protocolCode: .success, obj: result).makeResponse()
    }
    
    // aes128
    func aes128(_ req: Request) throws -> String {
        let value = try req.parameter(String.self)
        
        let key = "qwertgfdsa123490"
        
        let ciphertext = try AES128.encrypt(value, key: key)
        let originalData = try AES128.decrypt(ciphertext, key: key)
        
        let result = String(data: originalData, encoding: .utf8)!
        
        return ResponseWrapper(protocolCode: .success, obj: result).makeResponse()
    }
    
    // random
    func random(_ req: Request) throws -> String {
        let randomInt = try OSRandom().generate(UInt8.self) % 100
        
        return ResponseWrapper(protocolCode: .success, obj: randomInt).makeResponse()
    }
    
}
