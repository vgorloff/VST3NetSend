// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pkg = Package(name: "VST3NetSendShared")

pkg.platforms = [.macOS(.v10_13)]

pkg.products = [.library(name: "VST3NetSendShared", targets: ["VST3NetSendShared"])]

pkg.dependencies = [
   .package(url: "https://bitbucket.org/vgorloff/mcConcurrencyLocking.git", .upToNextMinor(from: "1.0.1")),
   .package(url: "https://bitbucket.org/vgorloff/mcFoundationExtensions.git", .upToNextMinor(from: "1.0.7")),
   .package(url: "https://bitbucket.org/vgorloff/mcFoundationLogging.git", .upToNextMinor(from: "1.0.4")),
   .package(url: "https://bitbucket.org/vgorloff/mcFoundationFormatters.git", .upToNextMinor(from: "1.0.3")),
   .package(url: "https://bitbucket.org/vgorloff/mcMediaExtensions.git", .upToNextMinor(from: "1.0.2")),
   .package(url: "https://bitbucket.org/vgorloff/mcMediaAU.git", .upToNextMinor(from: "1.0.1"))
]

pkg.targets = [
   .target(name: "VST3NetSendShared",
           dependencies: ["mcConcurrencyLocking", "mcFoundationExtensions", "mcFoundationLogging", "mcFoundationFormatters", "mcMediaExtensions", "mcMediaAU"],
           path: "Sources")
]
