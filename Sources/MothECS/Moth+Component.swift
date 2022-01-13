//
//  Moth+Component.swift
//  MothECS
//
//  Created by Junhao Wang on 1/12/22.
//

public protocol MothComponent: AnyObject {
    init()
}

// Component Pool
class MothComponentPool {
    // Identifiers
    private var componentIdentifierMap: [Int: MothComponentID] = [:]  // hash -> ID
    private var componentIDCounter: MothComponentID = 0
    
    // Pool: ID -> [MothComponent]
    private var typePools: [ContiguousArray<MothComponent?>] = []
    
    var componentTypeCount: Int { get {
        return Int(componentIDCounter)
    }}
    
    init() {
        
    }
    
    func getComponentID<T>(_ type: T.Type) -> MothComponentID where T: MothComponent {
        // Each component type has its own type hash value
        let typeHashValue: Int = ObjectIdentifier(type.self).hashValue
        
        if let id = componentIdentifierMap[typeHashValue] {
            return id
        } else {
            // register new component ID
            let newID: MothComponentID = componentIDCounter
            componentIdentifierMap[typeHashValue] = newID
            // create component pool
            typePools.append(ContiguousArray<MothComponent?>(repeating: nil, count: Moth.maxEntityCount))
            // update
            componentIDCounter += 1
            return newID
        }
    }
    
    func getComponent<T>(_ type: T.Type, from entityID: MothEntityID) -> T where T: MothComponent {
        guard let component: T = typePools[Int(getComponentID(type))][Int(entityID)] as? T else {
            fatalError("Please use hasComponent() to check component existence before calling getComponent()")
        }
        
        return component
    }
    
    func getComponentList<T>(_ type: T.Type) -> [T] where T: MothComponent {
        let list = typePools[Int(getComponentID(type))]
        return list.compactMap({ $0 as? T })
    }
    
    func createComponent<T>(_ type: T.Type, from entityID: MothEntityID) -> T where T: MothComponent {
        let t = T()
        typePools[Int(getComponentID(type))][Int(entityID)] = t
        return t
    }
    
    func assignComponent<T>(_ component: T, to type: T.Type, from entityID: MothEntityID) where T: MothComponent {
        typePools[Int(getComponentID(type))][Int(entityID)] = component
    }
    
    func removeComponent<T>(_ type: T.Type, from entityID: MothEntityID) -> T? where T: MothComponent {
        let componentID = getComponentID(type)
        let component = typePools[Int(componentID)][Int(entityID)]
        typePools[Int(componentID)][Int(entityID)] = nil
        return component as? T
    }
    
    func removeAllComponents(from entityID: MothEntityID) {
        for componentID in componentIdentifierMap.values {
            typePools[Int(componentID)][Int(entityID)] = nil
        }
    }
}

extension MothComponentPool: CustomStringConvertible {
    var description: String {
        "MothComponentPool: count=\(componentTypeCount), IDs=\(componentIdentifierMap.values)"
    }
}
