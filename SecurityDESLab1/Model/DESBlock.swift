//
//  DESBlock.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

class DESBlock: Block {
    
    // MARK: - Initialization
    
    convenience init(block: Block) {
        self.init(bytes: block.bytes)
    }
    
    // MARK: - Methods
    
    private func encrypted(withKeys keys: [Int]) -> Block {
        var block = self
        
        var leftPart = DESBlock(block: block.leftPart)
        var rightPart = DESBlock(block: block.rightPart)
        
        for j in 0..<16 {
            block = DESBlock(block: leftPart ^ DESBlock.makeFerstailFunc(forBlock: rightPart, withKey: keys[j]))
            leftPart = rightPart
            rightPart = block
        }
        
        return block
    }
    
    // MARK: - Static Methods
    
    private static func makeFerstailFunc(forBlock block: DESBlock, withKey key: Int) -> DESBlock {
        // TODO: Implement function
        return DESBlock(bytes: [UInt8](repeating: 0, count: 64))
    }

}
