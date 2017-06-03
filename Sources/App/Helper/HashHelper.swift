
class HashHelper {
    
    static func createToken(_ value: String) throws -> String {
        let hashBytes = try createHash(value.makeBytes())
        return String(bytes: hashBytes)
    }
    
    static func createHash(_ value: Bytes) throws -> Bytes {
        return try BCryptHasher(cost: 10).make(value)
    }

}
