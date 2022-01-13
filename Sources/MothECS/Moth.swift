//
//  Moth.swift
//  MothECS
//
//  Created by Junhao Wang on 1/12/22.
//

public class Moth {
    static let maxEntityCount: Int = 1000
    static let maxComponentCount: Int = 32  // Do not change! 32 is enough for now
    
    private var entities: [MothEntity] = []
    private var freeEntities: [MothEntityID] = []
    private let componentPool: MothComponentPool = MothComponentPool()
    
    public init() {
        
    }
    
    public func log() {
        print("MothECS:")
        for entity in entities {
            print(" -> \(entity)")
        }
        print("-- \(componentPool)")
    }
}

// MARK: - Entity Methods
extension Moth {
    public func createEntity() -> MothEntityID {
        guard entities.count < Self.maxEntityCount else {
            assertionFailure("Cannot create entity any more. Reached the limit: \(Self.maxEntityCount)")
            return .invalid
        }
        
        // Check if there is any freed ID
        if !freeEntities.isEmpty {
            let reusedID: MothEntityID = freeEntities.removeFirst()
            entities[Int(reusedID)] = MothEntity(id: reusedID)
            return reusedID
        } else {
            let entity = MothEntity(id: MothEntityID(entities.count))
            entities.append(entity)
            return entity.entityID
        }
    }
    
    @discardableResult
    public func removeEntity(entityID: MothEntityID) -> Bool {
        guard checkEntityID(entityID) else {
            return false
        }
        
        componentPool.removeAllComponents(from: entityID)
        entities[Int(entityID)] = MothEntity(id: .invalid)
        
        freeEntities.append(entityID)
        return true
    }
}

// MARK: - Single Component Methods
extension Moth {
    @discardableResult
    public func createComponent<T>(_ type: T.Type, to entityID: MothEntityID) -> T? where T: MothComponent {
        guard checkEntityID(entityID) && checkComponentPoolSize() else {
            return nil
        }
        
        let componentID = componentPool.getComponentID(T.self)
        entities[Int(entityID)].componentMask.set(componentID)  // Int is large enough
        
        let component: T = componentPool.createComponent(T.self, from: entityID)
        return component
    }

    @discardableResult
    public func assignComponent<T>(_ component: T, to entityID: MothEntityID) -> Bool where T: MothComponent {
        guard checkEntityID(entityID) && checkComponentPoolSize() else {
            return false
        }
        
        let componentID = componentPool.getComponentID(T.self)
        entities[Int(entityID)].componentMask.set(componentID)
        
        componentPool.assignComponent(component, to: T.self, from: entityID)
        return true
    }
    
    @discardableResult
    public func removeComponent<T>(_ type: T.Type, from entityID: MothEntityID) -> T? where T: MothComponent {
        guard checkEntityID(entityID) && checkComponentPoolSize() else {
            return nil
        }
        
        let componentID = componentPool.getComponentID(T.self)
        entities[Int(entityID)].componentMask.unset(componentID)
        return componentPool.removeComponent(type, from: entityID)
    }
    
    public func removeAllComponents(from entityID: MothEntityID) {
        guard checkEntityID(entityID) && checkComponentPoolSize() else {
            return
        }
        
        entities[Int(entityID)].componentMask.reset()
        componentPool.removeAllComponents(from: entityID)
    }
    
    @discardableResult
    public func getComponent<T>(_ type: T.Type, from entityID: MothEntityID) -> T where T: MothComponent {
        guard checkEntityID(entityID) else {
            fatalError("Cannot get component from invalid entity ID (\(entityID)")
        }
        
        return componentPool.getComponent(type, from: entityID)
    }

    @discardableResult
    public func hasComponent<T>(_ type: T.Type, in entityID: MothEntityID) -> Bool where T: MothComponent {
        guard checkEntityID(entityID) else {
            return false
        }
        
        let componentID = componentPool.getComponentID(type)
        return entities[Int(entityID)].componentMask.isComponentOn(componentID)
    }
}

// MARK: - Component View Methods
extension Moth {
    public func view<T>(_ type: T.Type) -> [MothEntityID] where T: MothComponent {
        let componentID = componentPool.getComponentID(type)
        let mask = MothComponentMask(indices: [componentID])
        return entities.filter({ $0.componentMask.contains(mask) }).map({ $0.entityID })
    }
    
    public func view<T1, T2>(_ type1: T1.Type, _ type2: T2.Type) -> [MothEntityID] where T1: MothComponent, T2: MothComponent {
        let componentID1 = componentPool.getComponentID(type1)
        let componentID2 = componentPool.getComponentID(type2)
        let mask = MothComponentMask(indices: [componentID1, componentID2])
        return entities.filter({ $0.componentMask.contains(mask) }).map({ $0.entityID })
    }
    
    public func view<T1, T2, T3>(_ type1: T1.Type, _ type2: T2.Type, _ type3: T3.Type)
    -> [MothEntityID] where T1: MothComponent, T2: MothComponent, T3: MothComponent {
        let componentID1 = componentPool.getComponentID(type1)
        let componentID2 = componentPool.getComponentID(type2)
        let componentID3 = componentPool.getComponentID(type3)
        let mask = MothComponentMask(indices: [componentID1, componentID2, componentID3])
        return entities.filter({ $0.componentMask.contains(mask) }).map({ $0.entityID })
    }
    
    // With Exceptions
    public func view<T>(excepts type: T.Type) -> [MothEntityID] where T: MothComponent {
        let componentID = componentPool.getComponentID(type)
        let mask = MothComponentMask(indices: [componentID])
        return entities.filter({ !$0.componentMask.contains(mask) }).map({ $0.entityID })
    }
    
    public func view<T1, T2>(_ type: T1.Type, excepts exceptType: T2.Type) -> [MothEntityID] where T1: MothComponent, T2: MothComponent {
        let componentID = componentPool.getComponentID(type)
        let exceptComponentID = componentPool.getComponentID(exceptType)
        let mask = MothComponentMask(indices: [componentID])
        let exceptMask = MothComponentMask(indices: [exceptComponentID])
        return entities.filter({ $0.componentMask.contains(mask) && !$0.componentMask.contains(exceptMask) }).map({ $0.entityID })
    }
    
    public func view<T1, T2, T3>(_ type1: T1.Type, _ type2: T2.Type, excepts exceptType: T3.Type)
    -> [MothEntityID] where T1: MothComponent, T2: MothComponent, T3: MothComponent {
        let componentID1 = componentPool.getComponentID(type1)
        let componentID2 = componentPool.getComponentID(type2)
        let exceptComponentID = componentPool.getComponentID(exceptType)
        let mask = MothComponentMask(indices: [componentID1, componentID2])
        let exceptMask = MothComponentMask(indices: [exceptComponentID])
        return entities.filter({ $0.componentMask.contains(mask) && !$0.componentMask.contains(exceptMask) }).map({ $0.entityID })
    }
    
    public func list<T>(_ type: T.Type) -> [T] where T: MothComponent {  // might be slow, use view()
        return componentPool.getComponentList(type)
    }
}

// MARK: - Check Helper Functions
extension Moth {
    private func checkEntityID(_ entityID: MothEntityID) -> Bool {
        guard entityID < entities.count else {
            assertionFailure("Cannot assign component to invalid entity ID (\(entityID)!")
            return false
        }
        
        guard entities[Int(entityID)].entityID != .invalid else {
            assertionFailure("The entity (\(entityID) has been removed!")
            return false
        }
        
        return true
    }
    
    private func checkComponentPoolSize() -> Bool {
        guard componentPool.componentTypeCount < Self.maxComponentCount else {
            assertionFailure("Cannot create component. Currently only supports \(Self.maxComponentCount) components!")
            return false
        }
        return true
    }
}
