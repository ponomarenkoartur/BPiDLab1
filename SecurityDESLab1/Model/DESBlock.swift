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
            guard let resultOfFeistailFunc = rightPart.applyingFeistailFunc(withKey: keys[j]) else { return nil }
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
        let permutated = DESBlock(bitsCount: permutatedSize)
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
    
    private func applyingFeistailFunc(withKey key: DESBlock) -> DESBlock? {
        var block = self
        guard let eExtended = block.permutated(withPermutationTable: DESTable.eExtension) else { return nil }
        block = eExtended
        
        block = DESBlock(block: block ^ key)
        
        guard let sTransformated = block.sTransformated() else { return nil }
        block = sTransformated
        
        guard let pPermutated = block.permutated(withPermutationTable: DESTable.pPermutation) else { return nil }
        block = pPermutated
        
        return block
    }
    
    public func splittingIntoBlocks(withSize blockSize: Int) -> [DESBlock] {
        var blocks: [DESBlock] = []
        let blocksCount = bitsCount / blockSize
        
        for j in 0..<blocksCount {
            let startIndex = j * blockSize
            let endIndex = startIndex + blockSize
            blocks.append(DESBlock(block: self[startIndex..<endIndex]))
        }
        
        return blocks
    }

}
