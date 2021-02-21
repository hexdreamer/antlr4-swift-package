// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright (c) 2012-2021 The ANTLR Project. All rights reserved.

// Use of this file is governed by the BSD 3-clause license that		
// can be found in the LICENSE.txt file in the project root.

import PackageDescription

let package = Package(
    name: "Antlr4",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Antlr4",
            targets: ["Antlr4"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Antlr4",
            dependencies: []),
        .testTarget(
            name: "Antlr4Tests",
            dependencies: ["Antlr4"]),
    ]
)
