import HTTP

class ResponseWrapper {

    fileprivate var mProtocolCode: ProtocolCode?
    fileprivate var mObj: JSON?
    
    init(obj: JSON) {
        self.mProtocolCode = ProtocolCode.Success
        self.mObj = obj
    }
    
    init(protocolCode: ProtocolCode, obj: JSON? = nil) {
        self.mProtocolCode = protocolCode
        self.mObj = obj
    }
    
}

extension ResponseWrapper: ResponseRepresentable {

    func makeResponse() throws -> Response {
        var json = JSON()
        if let mProtocolCode = mProtocolCode {
            try json.set("code", mProtocolCode.getCode())
            try json.set("msg", mProtocolCode.getMsg())
            
            if let mObj = mObj {
                try json.set("obj", mObj)
            }
        } else {
            try json.set("code", -1)
            try json.set("msg", "Unknow")
        }
        
        return try json.makeResponse()
    }
    
    func makeResponse(xtoken: String) throws -> Response {
        var json = JSON()
        if let mProtocolCode = mProtocolCode {
            try json.set("code", mProtocolCode.getCode())
            try json.set("msg", mProtocolCode.getMsg())
            
            if let mObj = mObj {
                try json.set("obj", mObj)
            }
        } else {
            try json.set("code", -1)
            try json.set("msg", "Unknow")
        }
        
        let headers: [HeaderKey: String] = [
            "XToken": xtoken
        ]
        return Response(status: Status.ok, headers: headers, body: json)
    }
    
}
