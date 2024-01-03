// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PageTemplate",
  platforms: [ .iOS(.v14) ],
  products: [
    .library(
      name: "PageTemplate",
      targets: ["PageTemplate"]),
  ],
  targets: [
    .target(
      name: "PageTemplate"),
    .testTarget(
      name: "PageTemplateTests",
      dependencies: ["PageTemplate"]),
  ]
)
