//
//  Moth+Entity.swift
//  MothECS
//
//  Created by Junhao Wang on 1/12/22.
//

struct MothEntity {
    let entityID: MothEntityID
    var componentMask: MothComponentMask = MothComponentMask()
    
    init(id: MothEntityID) {
        entityID = id
    }
}

extension MothEntity: CustomStringConvertible {
    var description: String {
        "MothEntity: id=\(entityID), \(componentMask)"
    }
}
