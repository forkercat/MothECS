# MothECS: Simple Entity Component System in Swift 📦

[![macOS](https://github.com/forkercat/MothECS/actions/workflows/ci-macos.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-macos.yml)
[![Linux](https://github.com/forkercat/MothECS/actions/workflows/ci-linux.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-linux.yml)
[![Windows](https://github.com/forkercat/MothECS/actions/workflows/ci-windows.yml/badge.svg)](https://github.com/forkercat/MothECS/actions/workflows/ci-windows.yml)
[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

[![platform-compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fforkercat%2FMothECS%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/forkercat/MothECS)
[![swift-version-compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fforkercat%2FMothECS%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/forkercat/MothECS)

MothECS is a simple entity component system written in Swift. It supports the following features:

- Use bitmask to manage relationship between entities and components
- Support view operation with optional excepted type
- Reuse destroyed entity in next creation

Future Development:

- Get entity ID from a component
- Support more components (currently it supports 32)
- Use sparse array

[Moth](https://www.pinterest.com/pin/587649451369676935/) in MothECS - It refers to new players in [Sky](https://www.thatskygame.com/). Explanation is [here](https://www.reddit.com/r/SkyGame/comments/q03tj4/why_are_new_players_called_moths/)!

<p align="left">
	<img src="https://64.media.tumblr.com/b84d16532adb0a618782d987255d8be2/3de7a74e664a6d26-79/s500x750/61bfbf123cbbfc2ec0b331dcea58d9f05c03bd88.jpg" width="30%" alt="This is moth!"/>
</p>

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

#### Import & Initialize

```swift
import MothECS

let moth = Moth()
moth.log()  // use this for showing bitmasks
```

#### Define Your Own Component Classes

```swift
class TagComponent: MothComponent {
    required init() { }
}

class TransformComponent: MothComponent {
    required init() { }
}

class LightComponent: MothComponent {
    required init() { }
}
```

#### Initialize & Create Entity

```swift
let e0: MothEntityID = moth.createEntity()
let e1: MothEntityID = moth.createEntity()
let e2: MothEntityID = moth.createEntity()
let e4: MothEntityID = moth.createEntity()
assert(e0 != .invalid)
_ = moth.entityIDs  // return all valid entity IDs
```

#### Create & Assign Comonent

```swift
moth.createComponent(TagComponent.self, to: e0)
moth.createComponent(TransformComponent.self, to: e0)
moth.createComponent(LightComponent.self, to: e0)   // e0: [Tag, Transform, Light]

moth.assignComponent(TagComponent(), to: e1)
moth.assignComponent(TransformComponent(), to: e1)  // e1: [Tag, Transform]
moth.assignComponent(LightComponent(), to: e2)
moth.assignComponent(TagComponent(), to: e2)        // e2: [Tag, Light]
```

#### Remove Entity & Component

```swift
moth.removeAllComponents(from: e4)                  // e4: []
moth.removeEntity(entityID: e4)                     // e4 is not invalid, its ID will be reused in next createEntity()
moth.removeComponent(TagComponent.self, from: e2)   // e2: [Light]
```

#### Get & Has Component

```swift
if moth.hasComponent(LightComponent.self, in: e2) {
    _ = moth.getComponent(LightComponent.self, from: e2)  // put getComponent() inside hasComponent()
}
```

#### View Operation

```swift
let v1 = moth.view(TagComponent.self, TransformComponent.self, LightComponent.self)
let v2 = moth.view(TagComponent.self, TransformComponent.self)
let v3 = moth.view(TagComponent.self, TransformComponent.self, excepts: LightComponent.self)

// v1: [e0]
// v2: [e0, e1]
// v2: [e1]
```


## 🙏 Reference

- [How to make a simple entity-component-system in C++](https://www.david-colson.com/2020/02/09/making-a-simple-ecs.html) by David Colson
- [fireblade-engine/ecs](https://github.com/fireblade-engine/ecs) by [@ctreffs](https://github.com/ctreffs)
