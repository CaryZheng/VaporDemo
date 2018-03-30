//
//  ResponseWrapper.swift
//  App
//
//  Created by CaryZheng on 2018/3/26.
//

import Foundation

class ResponseWrapper<T>: Codable where T: Codable {
    private var code: ProtocolCode!
    private var obj: T?
    
    init(protocolCode: ProtocolCode) {
        self.code = protocolCode
    }
    
    init(obj: T) {
        self.code = ProtocolCode.success
        self.obj = obj
    }
    
    init(protocolCode: ProtocolCode, obj: T) {
        self.code = protocolCode
        self.obj = obj
    }
    
    func makeResponse() -> String {
        var result = ""
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            result = String(data: data, encoding: .utf8)!
            print("result = \(String(describing: result))")
        } catch {
            print("Encode error")
        }
        
        return result
    }
    
}
