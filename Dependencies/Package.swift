// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pkg = Package(name: "VST3NetSendShared")

pkg.platforms = [
   .macOS(.v10_13)
]

pkg.products = [
   .library(name: "VST3NetSendShared", targets: ["VST3NetSendShared"])
]

pkg.dependencies = [
    .package(path: "../../Shared/mcConcurrency"),
   // .package(path: "../../mcUIKit"),
   // .package(path: "../../mcDB"),
   // .package(path: "../../mcAppServices"),
   // .package(path: "../../mcTestability"),
   // .package(path: "../../mcFoundation"),
   // .package(path: "../../mcRuntime"),
   // .package(path: "../../mcSecurity"),
   // .package(path: "../../mcMath")
]

pkg.targets = [
   .target(name: "VST3NetSendShared",
           dependencies: ["mcConcurrency"],
           path: "Sources"),
]
