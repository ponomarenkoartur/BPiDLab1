//
//  DESBlock.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

class DESBlock: Block {
    
    // MARK: - Methods
    
    private func encrypted(withKeys keys: [DESBlock]) -> DESBlock? {
        var block = DESBlock(block: self)
        
        guard let initialPermutated = block.permutated(withPermutationTable: DESTable.initialPermutation) else { return nil }
        block = initialPermutated
        
        var leftPart = DESBlock(block: block.leftPart)
        var rightPart = DESBlock(block: block.rightPart)
        
        for j in 0..<16 {
            guard let resultOfFeistailFunc = DESBlock.makeFeistailFunc(forBlock: rightPart, withKey: keys[j]) else { return nil }
            block = DESBlock(block: leftPart ^ resultOfFeistailFunc)
            leftPart = rightPart
            rightPart = block
        }
        
        guard let finalPermutated = block.permutated(withPermutationTable: DESTable.initialPermutation) else { return nil }
        block = finalPermutated
        
        return block
    }
    
    public func permutated(withPermutationTable permutationTable: [Int]) -> DESBlock? {
        guard let maxIndex = permutationTable.max(), maxIndex <= self.bitsCount else {
            return nil
        }
        let permutatedSize = permutationTable.count
        let permutated = DESBlock(bytes: [UInt8](repeating: 0, count: 8))
        for bitPosition in 0..<permutatedSize {
            let positionInTable = permutationTable[bitPosition] - 1
            permutated[bitPosition] = self[positionInTable]!
        }
        
        return permutated
    }
    
    public func sTransformated() -> DESBlock? {
        // TODO: Implement the func
        return DESBlock(bytes: [UInt8](repeating: 0, count: 64))
    }
    
    public func cycleShifted(by shift: Int, inDirection direction: ShiftDirection) -> DESBlock {
        let shift = shift % self.bitsCount
        let direction = (shift >= 0) ? direction : direction.reversed()
        
        let leftSlice: Block
        let rightSlice: Block
        
        switch direction {
        case .left:
            leftSlice = self[0..<shift]
            rightSlice = self[shift..<bitsCount]
        case .right:
            leftSlice = self[0..<(bitsCount-shift)]
            rightSlice = self[(bitsCount-shift)..<bitsCount]
        }
        
        return DESBlock(blocks: [rightSlice, leftSlice])
    }
    
    // MARK: - Static Methods
    
    private static func makeFeistailFunc(forBlock block: DESBlock, withKey key: DESBlock) -> DESBlock? {
        var block = block
        
        guard let eExtended = block.permutated(withPermutationTable: DESTable.eExtension) else { return nil }
        block = eExtended
        
        block = DESBlock(block: block ^ key)
        
        guard let sTransformated = block.sTransformated() else { return nil }
        block = sTransformated
        
        guard let pPermutated = block.permutated(withPermutationTable: DESTable.pPermutation) else { return nil }
        block = pPermutated
        
        return block
    }

}
