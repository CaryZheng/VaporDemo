@_exported import Vapor

extension Droplet {
    public func setup() throws {
        DropletHelper.droplet = self
        
        let routes = Routes(view)
        try collection(routes)
    }
}
