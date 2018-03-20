import FluentMySQL
import Vapor

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a SQLite database
    var mysqlConfig = DatabaseConfig()
    mysqlConfig.add(database: MySQLDatabase(hostname: "localhost", port: 3306, user: "ZWeatherUser", password: "ZWeatherUser123456", database: "ZWeather"), as: .mysql)
    services.register(mysqlConfig)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)

    // Configure the rest of your application here
}
