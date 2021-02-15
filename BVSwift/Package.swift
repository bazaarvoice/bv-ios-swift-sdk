// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BVSwift",
    products: [
        .library(
            name: "BVSwift",
            targets: ["BVSwift"]),
    ],
    dependencies: [
         .package(url: "", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BVSwift",
            dependencies: []),
        .testTarget(
            name: "BVSwiftTests",
            dependencies: ["BVSwift"]),
    ]
)

//let package = Package(
//    name: "BVSwift",
//    products: [
//        // Products define the executables and libraries a package produces, and make them visible to other packages.
//        .library(
//            name: "BVSwift",
//            targets: ["BVSwift", "SomeRemoteBinaryPackage", "SomeLocalBinaryPackage"])
//    ],
//    dependencies: [
//        // Dependencies declare other packages that this package depends on.
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages this package depends on.
//        .target(
//            name: "BVSwift",
//
//            exclude: ["instructions.md"],
//            resources: [
//                .process("text.txt"),
//                .process("example.png"),
//                .copy("settings.plist")
//            ]
//        ),
//        .binaryTarget(
//            name: "SomeRemoteBinaryPackage",
//            url: "https://url/to/some/remote/binary/package.zip",
//            checksum: "The checksum of the XCFramework inside the ZIP archive."
//        ),
//        .binaryTarget(
//            name: "SomeLocalBinaryPackage",
//            path: "path/to/some.xcframework"
//        )
//        .testTarget(
//            name: "BVSwiftTests",
//            dependencies: ["BVSwift"]),
//    ]
//)
