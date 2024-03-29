// swift-tools-version:5.8
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
    .package(
      url: "https://github.com/interactord/URLEncodedForm",
      .upToNextMajor(from: "1.0.8")),
    .package(
      url: "https://github.com/airbnb/swift",
      .upToNextMajor(from: "1.0.6")),
  ],
  targets: [
    .target(
      name: "LinkNavigator",
      dependencies: [
        "URLEncodedForm",
      ]),
    .testTarget(
      name: "LinkNavigatorTests",
      dependencies: ["LinkNavigator"]),
  ])
