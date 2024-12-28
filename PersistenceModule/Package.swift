// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PersistenceModule",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "PersistenceModule",
            targets: ["PersistenceModule"]),
    ],
    targets: [
        .target(
            name: "PersistenceModule",
            dependencies: [] // No direct dependency on Factory here
        ),
        .testTarget(
            name: "PersistenceModuleTests",
            dependencies: ["PersistenceModule"]),
    ]
)
