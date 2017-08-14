import MySQLProvider
import RedisProvider
import LeafProvider
import MarkdownProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
        setupMiddleware()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(MySQLProvider.Provider.self)
        try addProvider(RedisProvider.Provider.self)
        try addProvider(LeafProvider.Provider.self)
        try addProvider(MarkdownProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations += [
            User.self
        ]
    }
    
    private func setupMiddleware() {
        addConfigurable(middleware: MyMiddleware(), name: "MyMiddleware")
    }
    
}
