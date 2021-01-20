// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationPicker",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LocationPicker",
            targets: ["LocationPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mszmagic/SwiftUILibrary.git", from: "1.7.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LocationPicker",
            dependencies: ["SwiftUILibrary"]),
    ]
)
