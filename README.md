# MothECS - Simple Entity Component System in Swift 📋

[![macOS](https://github.com/forkercat/MothECS/actions/workflows/ci-macos.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-macos.yml)
[![Linux](https://github.com/forkercat/MothECS/actions/workflows/ci-linux.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-linux.yml)
[![Windows](https://github.com/forkercat/MothECS/actions/workflows/ci-windows.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-windows.yml)
[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

[![platform-compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fforkercat%2FMothECS%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/forkercat/MothECS)
[![swift-version-compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fforkercat%2FMothECS%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/forkercat/MothECS)

MothECS is a simple entity component system written in Swift. It supports the following features:

- Use bitmask to manage relationship between entities and components
- 

Future Development:

- Support more components
- Use sparse array

## 🔧 Install

You package file would be like:

```swift
let package = Package(
    name: "YourPackageName",
    
    dependencies: [
        .package(url: "https://github.com/forkercat/MothECS.git", .branch("main")),
    ],
    
    targets: [
        // For Swift 5.5, use .executableTarget
        .target(
            name: "YourPackageName",
            dependencies: [
                .product(name: "MothECS", package: "MothECS")
            ]),
    ]
)
```


## 😆 Usage

### Option 1️⃣: Use Logger object

```swift
import OhMyLog

var logger = Logger(name: "Example-1", level: .info)
logger.logLevel = .trace
logger.showLevelIcon = true

let list = ["Oh", "My", "Log"]

logger.trace("Hello, World! \(list)")
logger.debug("Hello, World! \(list)")
logger.info("Hello, World! \(list)")
logger.warn("Hello, World! \(list)")
logger.error("Hello, World! \(list)")
logger.fatal("Hello, World! \(list)")

// Output
🟤 [06:52:31.672] TRACE Example-1: Hello, World! ["Oh", "My", "Log"]
🟢 [06:52:31.672] DEBUG Example-1: Hello, World! ["Oh", "My", "Log"]
⚪️ [06:52:31.673] INFO Example-1: Hello, World! ["Oh", "My", "Log"]
🟡 [06:52:31.673] WARN Example-1: Hello, World! ["Oh", "My", "Log"]
🔴 [06:52:31.673] ERROR Example-1: Hello, World! ["Oh", "My", "Log"]
🚨 [06:52:31.673] FATAL Example-1: Hello, World! ["Oh", "My", "Log"]
```


## 🙏 Reference

- [How to make a simple entity-component-system in C++](https://www.david-colson.com/2020/02/09/making-a-simple-ecs.html) by David Colson
- [fireblade-engine/ecs](https://github.com/fireblade-engine/ecs) by [@ctreffs](https://github.com/ctreffs)
