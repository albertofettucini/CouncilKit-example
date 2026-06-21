// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CouncilKitExample",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/albertofettucini/CouncilKit.git", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "CouncilKitExample",
            dependencies: [.product(name: "CouncilKit", package: "CouncilKit")]
        ),
    ]
)
