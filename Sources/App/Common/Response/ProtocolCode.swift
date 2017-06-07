
enum ProtocolCode: Int {
    case Success = 200
    
    case FailParamError = 400
    case FailTokenInvalid = 401
    
    case FailInternalError = 500
    
    case FailSignIn = 10000
    case FailAccountHasExisted = 10001
    
    func getMsg() -> String {
        return "\(self)"
    }
    
    func getCode() -> Int {
        return self.rawValue
    }
    
}
