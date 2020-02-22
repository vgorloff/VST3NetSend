// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pkg = Package(name: "VST3NetSendShared")

pkg.platforms = [.macOS(.v10_13)]

pkg.products = [.library(name: "VST3NetSendShared", targets: ["VST3NetSendShared"])]

pkg.dependencies = [
   .package(path: "../node_modules/mc-concurrency-locking"),
   .package(path: "../node_modules/mc-foundation-extensions"),
   .package(path: "../node_modules/mc-foundation-formatters"),
   .package(path: "../node_modules/mc-foundation-logging"),
   .package(path: "../node_modules/mc-media-au"),
   .package(path: "../node_modules/mc-media-extensions")
]

pkg.targets = [
   .target(name: "VST3NetSendShared",
           dependencies: ["mcConcurrencyLocking", "mcFoundationExtensions", "mcFoundationLogging", "mcFoundationFormatters", "mcMediaExtensions", "mcMediaAU"],
           path: "Sources")
]
