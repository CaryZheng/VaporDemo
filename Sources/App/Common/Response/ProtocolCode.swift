
enum ProtocolCode: Int {
    case Success = 200
    case FailSignIn = 10000
    case FailParamError = 10001
    
    func getMsg() -> String {
        return "\(self)"
    }
    
    func getCode() -> Int {
        return self.rawValue
    }
    
}
