// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Sumi",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Sumi",
            targets: ["Sumi"]
        ),
        .executable(
            name: "SumiApp",
            targets: ["SumiApp"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-markdown.git",
            from: "0.5.0"
        ),
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            from: "7.0.0"
        ),
    ],
    targets: [
        .target(
            name: "Sumi",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "GRDB", package: "GRDB.swift"),
            ],
            path: "Sources/Sumi"
        ),
        .executableTarget(
            name: "SumiApp",
            dependencies: ["Sumi"],
            path: "Sources/SumiApp"
        ),
        .testTarget(
            name: "SumiTests",
            dependencies: ["Sumi"],
            path: "Tests/SumiTests"
        ),
    ]
)
