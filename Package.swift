// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BVSwift",
  platforms: [.iOS(.v9)],
  products: [
    .library(
      name: "BVSwift",
      targets: ["BVSwift"]
    )
  ],
  
  dependencies: [],
  
  targets: [
    .target(name: "BVSwift", path: "BVSwift", exclude: ["Support"]),
    .testTarget(
      name: "BVSwiftTests",
      dependencies: ["BVSwift"],
      path: "BVSwiftTests",
      exclude: ["Info.plist"],
      resources: [.process("MockData")]
    )
    
  ]
)
