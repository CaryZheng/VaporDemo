@_exported import Vapor

extension Droplet {
    public func setup() throws {
        DropletHelper.droplet = self
        
        try collection(V1Collection(view))
    }
}
