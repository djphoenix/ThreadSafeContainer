// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ThreadSafeContainer",
  products: [
    .library(name: "RWLock", targets: ["RWLock"]),
    .library(name: "ThreadSafeContainer", targets: ["ThreadSafeContainer"]),
  ],
  targets: [
    .target(name: "RWLock"),
    .target(name: "ThreadSafeContainer", dependencies: ["RWLock"]),
    .testTarget(name: "ThreadSafe-Tests", dependencies: ["ThreadSafeContainer"])
  ]
)
