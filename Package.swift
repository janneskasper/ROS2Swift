// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ROS2Swift",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ROS2Swift",
            targets: ["ROS2Swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/janneskasper/FastRTPSSwift.git", branch: "bugfix"),
//        .package(path: "/Users/jannes.kasper/Documents/git/FastRTPSSwift")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ROS2Swift",
            dependencies: [.product(name: "FastRTPSBridge", package: "FastRTPSSwift")]),
        .testTarget(
            name: "ROS2SwiftTests",
            dependencies: ["ROS2Swift", .product(name: "FastRTPSBridge", package: "FastRTPSSwift")]),
        .executableTarget(name: "ROS2SwiftExe",
                         dependencies: ["ROS2Swift"])
    ]
)
