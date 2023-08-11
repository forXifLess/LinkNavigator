// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LinkNavigator",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "LinkNavigator",
      targets: ["LinkNavigator"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "LinkNavigator",
      dependencies: []),
    .testTarget(
      name: "LinkNavigatorTests",
      dependencies: ["LinkNavigator"]),
  ])
