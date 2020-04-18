// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "CombineOperatorsCore",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "CombineOperatorsCore", targets: ["CombineOperatorsCore"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CombineOperatorsCore", path: "Sources"),
        .testTarget(name: "CombineOperatorsCore-Tests", dependencies: ["CombineOperatorsCore"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
