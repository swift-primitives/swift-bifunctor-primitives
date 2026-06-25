// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-bifunctor-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Bifunctor Primitives",
            targets: ["Bifunctor Primitives"]
        ),
        .library(
            name: "Bifunctor Primitives Test Support",
            targets: ["Bifunctor Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-pair-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-either-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Bifunctor Primitives",
            dependencies: [
                .product(name: "Pair Primitives", package: "swift-pair-primitives"),
                .product(name: "Either Primitives", package: "swift-either-primitives"),
            ]
        ),
        .target(
            name: "Bifunctor Primitives Test Support",
            dependencies: [
                "Bifunctor Primitives",
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Bifunctor Primitives Tests",
            dependencies: [
                "Bifunctor Primitives",
                "Bifunctor Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
