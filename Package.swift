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
    ),
    .library(
        name: "BVSwiftNoIDFA",
        targets: ["BVSwiftNoIDFA"]
    ),
  ],
  
  dependencies: [],
  
  targets: [
    .target(name: "BVSwift", path: "BVSwift", exclude: ["Support"]),
    // current workaround to avoid exclusive path checks is to use a symlink:
    // https://forums.swift.org/t/spm-shared-targets-files-use-case-whats-the-alternative/38888/4
    // pitch with possible solution:
    // https://forums.swift.org/t/pitch-mutually-exclusive-groups-of-targets/47518
    .target(
        name: "BVSwiftNoIDFA",
        dependencies: [],
        path: "BVSwiftNoIDFA",
        exclude: ["Support"],
        swiftSettings: [.define("DISABLE_BVSDK_IDFA")]
    ),
    .testTarget(
      name: "BVSwiftTests",
      dependencies: ["BVSwift"],
      path: "BVSwiftTests",
      exclude: ["Info.plist"],
      resources: [.process("MockData")]
    )
    
  ]
)
