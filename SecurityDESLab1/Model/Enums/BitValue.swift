//
//  BitValue.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

public enum BitValue: UInt8, CustomStringConvertible {
    case zero = 0
    case one = 1
    
    public var description: String {
        return self == .one ? "1" : "0"
    }
}
