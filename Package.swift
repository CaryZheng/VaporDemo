// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporDemo",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),
        // mysql
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.2"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.3")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor", "SwiftProtobuf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)

