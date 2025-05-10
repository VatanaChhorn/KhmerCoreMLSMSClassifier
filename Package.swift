// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KhmerCoreMLSMSClassifier",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "KhmerCoreMLSMSClassifier",
            targets: ["KhmerCoreMLSMSClassifier"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KhmerCoreMLSMSClassifier",
            resources: [
                .copy("Resources/kh-sms-classifier.mlmodelc"),
            ]),
        .testTarget(
            name: "KhmerCoreMLSMSClassifierTests",
            dependencies: ["KhmerCoreMLSMSClassifier"]
        ),
    ]
)
