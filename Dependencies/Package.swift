// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let pkg = Package(name: "VST3NetSendShared")

pkg.platforms = [.macOS(.v10_13)]

pkg.products = [.library(name: "VST3NetSendShared", targets: ["VST3NetSendShared"])]

pkg.dependencies = [.package(url: "https://bitbucket.org/vgorloff/mcConcurrencyLocking.git", .exact("1.0.0")),
                    .package(url: "https://bitbucket.org/vgorloff/mcFoundationExtensions.git", .exact("1.0.1")),
                    .package(url: "https://bitbucket.org/vgorloff/mcFoundationLogging.git", .exact("1.0.1")),
                    .package(url: "https://bitbucket.org/vgorloff/mcFoundationFormatters.git", .exact("1.0.0")),
                    .package(url: "https://bitbucket.org/vgorloff/mcMediaExtensions.git", .exact("1.0.1")),
                    .package(url: "https://bitbucket.org/vgorloff/mcMediaAU.git", .exact("1.0.0"))]

pkg.targets = [.target(name: "VST3NetSendShared",
                       dependencies: ["mcConcurrencyLocking", "mcFoundationExtensions", "mcFoundationLogging", "mcFoundationFormatters", "mcMediaExtensions", "mcMediaAU"],
                       path: "Sources")]
