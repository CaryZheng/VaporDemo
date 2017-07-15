
class RequestHelper {
	
    static func getXToken(request: Request) -> String? {
        return request.headers["XToken"]?.string
    }
    
}
