//
//  Moth+Mask.swift
//  MothECS
//
//  Created by Junhao Wang on 1/12/22.
//

struct MothComponentMask {
    private var mask: UInt32 = 0
    
    init() {
        
    }
    
    init(indices: [MothComponentID]) {
        for index in indices {
            set(index)
        }
    }
    
    mutating func set(_ index: MothComponentID) {
        mask |= (1 << index)
    }
    
    mutating func unset(_ index: MothComponentID) {
        mask &= ~(1 << index)
    }
    
    mutating func reset() {
        mask = 0
    }
    
    func isComponentOn(_ index: MothComponentID) -> Bool {
        let result = (mask >> index) & 1
        return result != 0
    }
    
    func contains(_ otherMask: MothComponentMask) -> Bool {
        return otherMask.mask == (otherMask.mask & mask)
    }
}

extension MothComponentMask: Equatable {
    static func == (lhs: MothComponentMask, rhs: MothComponentMask) -> Bool {
        return lhs.mask == rhs.mask
    }
}

extension MothComponentMask: CustomStringConvertible {
    var description: String {
        let str = String(mask, radix: 2).pad(with: "0",
                                             toLength: Moth.maxComponentCount)
        return "ComponentMask: [\(String(str.reversed()))]"
    }
}

extension String {
    fileprivate func pad(with padding: Character, toLength length: Int) -> String {
        let paddingWidth = length - self.count
        guard 0 < paddingWidth else { return self }
        return String(repeating: padding, count: paddingWidth) + self
    }
}

