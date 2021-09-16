// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Asura",
    products: [
        .library(name: "LMDB", targets: ["LMDB"]),
    ],
    targets: [
        .target(name: "CLMDB"),
        .target(name: "LMDB", dependencies: ["CLMDB"]),
        .testTarget(name: "LMDBTest", dependencies: ["LMDB"]),
    ]
)
