//
//  DESBlock.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

import Foundation

class DESBlock: Block {
    
    var entropies: [Double] = []
    
    // MARK: - Methods
    
    public func encrypted(withKeys keys: [DESBlock]) -> DESBlock? {
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
            
            // calculating entropy on current encoding iteration
            entropies.append(DESBlock(blocks: [leftPart, rightPart]).getEntropy())
        }
        
        block = DESBlock(blocks: [rightPart, leftPart])
        
        guard let finalPermutated = block.permutated(withPermutationTable: DESTable.finalPermutation) else { return nil }
        block = finalPermutated
        
        return block
    }
    
    public func decrypted(withKeys keys: [DESBlock]) -> DESBlock? {
        return encrypted(withKeys: keys.reversed())
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
    
    public func sTransformed() -> DESBlock? {
        guard self.bitsCount == 48 else { return nil }
        
        let sixBitsBlocks = self.splittingIntoBlocks(withSize: 6)
        var fourBitsBlocks: [DESBlock] = []
        for (blockIndex, block) in sixBitsBlocks.enumerated() {
            guard let fourBitsBlock = DESBlock.compress6BitsBlock(block, to4BitsWithSTable: DESTable.sTransformation[blockIndex]) else { return nil }
            fourBitsBlocks.append(fourBitsBlock)
        }
        return DESBlock(blocks: fourBitsBlocks)
    }
    
    private func applyingFeistailFunc(withKey key: DESBlock) -> DESBlock? {
        var block = self
        guard let eExtended = block.permutated(withPermutationTable: DESTable.eExtension) else { return nil }
        block = eExtended
        
        block = DESBlock(block: block ^ key)
        
        guard let sTransformated = block.sTransformed() else { return nil }
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
    
    private func getEntropy() -> Double {
        let onesCount = self.reduce(0) { $0 + $1.rawValue }
        let pOne = Double(onesCount) / Double(bitsCount)
        let pZero = 1 - pOne
        return -1 * (pOne * log2(pOne) + pZero * log2(pZero))
    }
    
    // MARK: - Static Methods
    
    public static func compress6BitsBlock(_ block: DESBlock, to4BitsWithSTable sTable: [[Int]]) -> DESBlock? {
        guard block.bitsCount == 6 else { return nil }
        
        let sTableCoordinates = DESBlock.getSTableCoordinates(from6BitsBlock: block)
        
        let transformedBlockBits = UInt8(sTable[sTableCoordinates.row][sTableCoordinates.column]) << 4
        return DESBlock(bytes: [transformedBlockBits], bitsCount: 4)
    }
    
    public static func getSTableCoordinates(from6BitsBlock block: DESBlock) -> (row: Int, column: Int) {
        let row = Int((block[0]!.rawValue << 1) | block[5]!.rawValue)
        let column = Int((block[1]!.rawValue << 3) |
            (block[2]!.rawValue << 2) |
            (block[3]!.rawValue << 1) |
            (block[4]!.rawValue))
        
        return (row, column)
    }

}
