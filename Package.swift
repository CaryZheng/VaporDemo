import PackageDescription

let package = Package(
    name: "VaporDemo",
    targets: [
        Target(name: "App"),
        Target(name: "Run", dependencies: ["App"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        // mysql
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 2),
        // redis
        .Package(url: "https://github.com/vapor/redis-provider.git", majorVersion: 2),
        // crypto
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0),
        // leaf
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1),
        // markdown
        .Package(url: "https://github.com/vapor-community/markdown-provider.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

