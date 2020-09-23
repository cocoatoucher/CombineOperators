// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineOperatorsCore",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "CombineOperatorsCore", targets: ["CombineOperatorsCore"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CombineOperatorsCore"),
        .testTarget(name: "CombineOperatorsCoreTests", dependencies: ["CombineOperatorsCore"])
    ],
    swiftLanguageVersions: [.v5]
)
