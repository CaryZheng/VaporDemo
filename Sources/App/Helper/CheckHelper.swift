
class CheckHelper {
	
    static func checkTokenValid(request: Request) throws {
        let xtoken = request.headers["XToken"]?.string
        if let xtoken = xtoken {
            if !TokenHelper.isXTokenValid(xtoken) {
                throw MyException.tokenInvalid
            }
        } else {
            throw MyException.tokenInvalid
        }
    }
    
}
