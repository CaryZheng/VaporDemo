@_exported import Vapor

extension Droplet {
    public func setup() throws {
        DropletHelper.droplet = self
        
        try collection(Routes.self)
    }
}
