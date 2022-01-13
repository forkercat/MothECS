// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MothECS",
    
    products: [
        .library(
            name: "MothECS",
            targets: ["MothECS"]),
    ],
    
    dependencies: [],
    
    targets: [
        .target(
            name: "MothECS",
            dependencies: []),
        
        .target(
            name: "MothECS-Demo",
            dependencies: [
                "MothECS"
            ])
    ]
)
