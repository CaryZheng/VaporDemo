import CryptoSwift
import Foundation

class TokenHelper {
    
    static func createHashPassword(_ value: String) throws -> String {
        let hashBytes = try CryptoHasher(hash: .sha256, encoding: .base64).make(value.makeBytes())
        return String(bytes: hashBytes)
    }
    
    static func createXToken(userId: String) throws -> String {
        let value = buildXTokeOriginalValueFormat(userId: userId)
        
        let key = DropletHelper.getDroplet().config["aes", "key"]?.string
        let encrypted = try AES(key: key!.makeBytes()).encrypt(value.makeBytes())
        
        return encrypted.base64Encoded.makeString()
    }
    
    static func parseXToken(_ value: String) throws -> String {
        let key = DropletHelper.getDroplet().config["aes", "key"]?.string
        let dencrypted = try value.makeBytes().base64Decoded.decrypt(cipher: AES(key: key!.makeBytes()))
        
        let values = dencrypted.makeString().components(separatedBy: "_")
        
        if values.count < 1 {
            throw Abort(.badRequest, reason: "Fail to parse XToken")
        }
        
        return values[0]
    }
    
    fileprivate static func buildXTokeOriginalValueFormat(userId: String) -> String {
        return userId + "_" + String(Date().timeIntervalSince1970)
    }
    
}
