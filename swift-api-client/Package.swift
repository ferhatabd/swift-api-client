// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Product definitions
extension Product {
    static var apiClient: Product { .library(name: "ApiClient", targets: ["ApiClient"]) }
    static var apiClientLive: Product { .library(name: "ApiClientLive", targets: ["ApiClientLive"]) }
    static var apiRoutes: Product  { .library(name: "ApiRoutes", targets: ["ApiRoutes"]) }
    static var sharedModels: Product { .library(name: "SharedModels", targets: ["SharedModels"]) }
}

// MARK: - Target dependencies
extension Target.Dependency {
    
    // MARK: 3rd party
    static var alamofire: Self { .product(name: "Alamofire", package: "Alamofire") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    
    // MARK: Local
    static var apiClient: Self { .target(name: "ApiClient") }
    static var apiClientLive: Self { .target(name: "ApiClientLive") }
    static var apiRoutes: Self { .target(name: "ApiRoutes") }
    static var sharedModels: Self { .target(name: "SharedModels") }
}

// MARK: - Targets
extension Target {
    static var apiRoutes: Target {
        .target(
            name: "ApiRoutes",
            dependencies: [
                .alamofire,
                .dependencies,
                .sharedModels
            ]
        )
    }
    static var apiClient: Target {
        .target(
            name: "ApiClient",
            dependencies: [
                .apiRoutes,
                .sharedModels
            ]
        )
    }
    static var apiClientLive: Target {
        .target(
            name: "ApiClientLive",
            dependencies: [
                .apiClient,
                .sharedModels,
                .dependencies
            ]
        )
    }
    static var sharedModels: Target {
        .target(
            name: "SharedModels",
            dependencies: []
        )
    }
}

let package = Package(
    name: "ApiClient",
    platforms: [.iOS(.v15)],
    products: [
        .apiClient,
        .apiClientLive,
        .apiRoutes,
        .sharedModels
    ],
    dependencies: [
        // Alamofire
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        // pointfreeco/swift-dependencies
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0")
    ],
    targets: [
        .apiClient,
        .apiClientLive,
        .apiRoutes,
        .sharedModels
    ]
)
