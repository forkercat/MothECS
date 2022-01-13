//
//  Moth+Identifiers.swift
//  MothECS
//
//  Created by Junhao Wang on 1/12/22.
//

public typealias MothEntityID = UInt32

extension MothEntityID {
    public static let invalid: MothEntityID = MothEntityID.max
}

public typealias MothComponentID = UInt32
