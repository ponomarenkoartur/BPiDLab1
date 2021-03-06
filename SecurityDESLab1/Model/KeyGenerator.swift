//
//  KeyGenerator.swift
//  SecurityDESLab1
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

class KeyGenerator {
    
    // MARK: - Properties
    
    let initialKey: DESBlock
    
    // MARK: - Initialization
    
    init?(initialKey: DESBlock) {
        guard initialKey.bitsCount == 64 else { return nil }
        self.initialKey = initialKey
    }
    
    // MARK: - Methods
    
    public func getKeys() -> [DESBlock] {
        var keys: [DESBlock] = []
        
        let initialPermutated = initialKey.permutated(withPermutationTable: DESTable.initialKeyPermutation)!
        var c = initialPermutated.leftPart
        var d = initialPermutated.rightPart
        
        for j in 0..<16 {
            c = DESBlock(block: c <<< DESTable.keyShift[j])
            d = DESBlock(block: d <<< DESTable.keyShift[j])
            let cd = DESBlock(blocks: [c, d])
            let key = cd.permutated(withPermutationTable: DESTable.finalKeyPermutation)!
            keys.append(key)
        }
        
        return keys
    }
}
