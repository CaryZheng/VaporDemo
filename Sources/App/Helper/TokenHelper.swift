
class TokenHelper {
    
    static func createToken(_ value: String) throws -> String {
        let hashBytes = try CryptoHasher(hash: .sha256, encoding: .base64).make(value.makeBytes())
        return String(bytes: hashBytes)
    }
    
}
