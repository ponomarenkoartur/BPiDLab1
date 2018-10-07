//
//  ShiftDirection.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

enum ShiftDirection {
    case left, right
    
    public func reversed() -> ShiftDirection {
        return (self == .left) ? .right : .left
    }
}
