// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "NavigationKit",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: "NavigationKit", targets: ["NavigationKit"]),
    ],
    targets: [
        .target(name: "NavigationKit", path: "./src"),
    ]
)
