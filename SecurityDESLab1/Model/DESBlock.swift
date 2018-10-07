//
//  DESBlock.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

class DESBlock: Block {
    private func encryptedBlock(withKeys keys: [Int]) -> Block {
        var leftPart = self.leftPart()
        var rightPart = self.rightPart()
        
        for j in 0..<16 {
            let block = leftPart! ^ makeFerstailFunc(forBlock: rightPart!, andKey: keys[j])
            leftPart = rightPart
            rightPart = block
        }
    }
    
    private static func makeFerstailFunc(forBlock block: Block, andKey key: Int) -> Block {
        // TODO: Implement function
        return Block(bytes: [UInt8](repeating: 0, count: 64))
    }

}
