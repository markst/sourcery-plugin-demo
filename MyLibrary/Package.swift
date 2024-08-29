// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MyLibrary",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "MyLibrary",
      targets: ["MyLibrary"]),
  ],
  dependencies: [
    .package(path: "../spm-build-tools")
  ],
  targets: [
    .target(
      name: "MyLibrary",
      plugins: [
        .plugin(name: "SourceryPlugin", package: "spm-build-tools")
      ]
    ),
    .testTarget(
      name: "MyLibraryTests",
      dependencies: ["MyLibrary"],
      plugins: [
        .plugin(name: "SourceryPlugin", package: "spm-build-tools")
      ]
    )
  ]
)
