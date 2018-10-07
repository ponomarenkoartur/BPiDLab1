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
    
    private func encrypted(withKeys keys: [Int]) -> Block? {
        var block = DESBlock(block: self)
        
        guard let initialPermutated = block.permutated(withPermutationTable: DESTable.initialPermutation) else { return nil }
        block = initialPermutated
        
        var leftPart = DESBlock(block: block.leftPart)
        var rightPart = DESBlock(block: block.rightPart)
        
        for j in 0..<16 {
            block = DESBlock(block: leftPart ^ DESBlock.makeFerstailFunc(forBlock: rightPart, withKey: keys[j]))
            leftPart = rightPart
            rightPart = block
        }
        
        guard let finalPermutated = block.permutated(withPermutationTable: DESTable.initialPermutation) else { return nil }
        block = finalPermutated
        
        return block
    }
    
    public func permutated(withPermutationTable permutationTable: [Int]) -> DESBlock? {
        guard let maxIndex = permutationTable.max(), maxIndex <= self.bitCount else {
            return nil
        }
        let permutatedSize = permutationTable.count
        let permutated = DESBlock(bytes: [UInt8](repeating: 0, count: 8))
        for bitPosition in 0..<permutatedSize {
            let positionInTable = DESEncryptor.initialPermutationTable[bitPosition] - 1
            let newBitValue = self.getBit(atPosition: positionInTable)!
            permutated.setBit(atPosition: bitPosition, toValue: newBitValue)
        }
        
        return permutated
    }
    
    // MARK: - Static Methods
    
    private static func makeFerstailFunc(forBlock block: DESBlock, withKey key: Int) -> DESBlock {
        // TODO: Implement function
        return DESBlock(bytes: [UInt8](repeating: 0, count: 64))
    }

}
