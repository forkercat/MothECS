//
//  main.swift
//  MothECS-Demo
//
//  Created by Junhao Wang on 1/12/22.
//

import MothECS

// Define your own component classes
class TagComponent: MothComponent {
    required init() { }
}

class TransformComponent: MothComponent {
    required init() { }
}

class LightComponent: MothComponent {
    required init() { }
}

let moth = Moth()

// Create Entity
let e0: MothEntityID = moth.createEntity()
let e1: MothEntityID = moth.createEntity()
let e2: MothEntityID = moth.createEntity()
let e4: MothEntityID = moth.createEntity()

assert(e0 != .invalid)

// Create Component
moth.createComponent(TagComponent.self, to: e0)
moth.createComponent(TransformComponent.self, to: e0)
moth.createComponent(LightComponent.self, to: e0)   // e0: [Tag, Transform, Light]

// Assign Component
moth.assignComponent(TagComponent(), to: e1)
moth.assignComponent(TransformComponent(), to: e1)  // e1: [Tag, Transform]
moth.assignComponent(LightComponent(), to: e2)
moth.assignComponent(TagComponent(), to: e2)        // e2: [Tag, Light]

// Remove Entity/Component
moth.removeAllComponents(from: e4)                  // e4: []
moth.removeEntity(entityID: e4)                     // e4 is not invalid, its ID will be reused in next createEntity()
moth.removeComponent(TagComponent.self, from: e2)   // e2: [Light]

// Show Debug Info
moth.log()

// Has/Get Component
if moth.hasComponent(LightComponent.self, in: e2) {
    _ = moth.getComponent(LightComponent.self, from: e2)  // put getComponent() inside hasComponent()
}

// View Component
let v1 = moth.view(TagComponent.self, TransformComponent.self, LightComponent.self)           // v1: [e0]
let v2 = moth.view(TagComponent.self, TransformComponent.self)                                // v2: [e0, e1]
let v3 = moth.view(TagComponent.self, TransformComponent.self, excepts: LightComponent.self)  // v2: [e1]

print(v1)  // [0]
print(v2)  // [0, 1]
print(v3)  // [1]
