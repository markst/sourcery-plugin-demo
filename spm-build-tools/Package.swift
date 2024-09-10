// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.iOS(.v14)],
    products: [
        .plugin(
            name: "SourceryPlugin",
            targets: ["SourceryPlugin"]
        ),
        .library(
            name: "TestMocks",
            targets: ["TestMocks"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/MakeAWishFoundation/SwiftyMocky.git", from: "4.2.0")
    ],
    targets: [
        .target(
            name: "TestMocks",
            dependencies: ["SwiftyMocky"],
            path: "./SwiftyMocky"
        ),
        .plugin(
            name: "SourceryPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "Sourcery")
            ]
        ),
        .binaryTarget(
            name: "Sourcery",
            path: "Binaries/Sourcery.artifactbundle"
        )
    ]
)
