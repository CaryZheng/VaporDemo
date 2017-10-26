import CryptoSwift
import Foundation

class TokenHelper {
    
    fileprivate static let AES_IV = "drowssapdrowssao"
    
    static func createHashPassword(_ value: String) throws -> String {
        let hashBytes = try CryptoHasher(hash: .sha256, encoding: .base64).make(value.makeBytes())
        return String(bytes: hashBytes)
    }
    
    static func createXToken(userId: String) throws -> String {
        let value = buildXTokeOriginalValueFormat(userId: userId)
        
        let key = DropletHelper.getDroplet().config["aes", "key"]?.string
        let encrypted = try AES(key: key!, iv: AES_IV).encrypt(value.makeBytes())
        
        return encrypted.base64Encoded.makeString()
    }
    
    static func parseXToken(_ value: String) throws -> String {
        let key = DropletHelper.getDroplet().config["aes", "key"]?.string
        let dencrypted = try value.makeBytes().base64Decoded.decrypt(cipher: AES(key: key!, iv: AES_IV))

        let values = dencrypted.makeString().components(separatedBy: "_")

        if values.count < 1 {
            throw MyException.tokenInvalid
        }

        return values[0]
    }
    
    static func isXTokenValid(_ value: String) -> Bool {
        do {
            let _ = try parseXToken(value)
        } catch {
            return false
        }
        
        return true
    }
    
    fileprivate static func buildXTokeOriginalValueFormat(userId: String) -> String {
        return userId + "_" + String(Date().timeIntervalSince1970)
    }
    
}
