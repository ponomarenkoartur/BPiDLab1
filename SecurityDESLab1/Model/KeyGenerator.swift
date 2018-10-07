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
    
    // MARK: - Computed Properties
    
    lazy var keys = getKeys()
    
    // MARK: - Initialization
    
    init?(initialKey: DESBlock) {
        guard initialKey.bitsCount == 64 else { return nil }
        self.initialKey = initialKey
    }
    
    // MARK: - Methods
    
    private func getKeys() -> [DESBlock] {
        var keys: [DESBlock] = []
        
        for j in 0..<16 {
            let c = DESBlock(block: initialKey.leftPart).permutated(withPermutationTable: DESTable.cPermutation)
            let d = DESBlock(block: initialKey.rightPart).permutated(withPermutationTable: DESTable.dPermutation)
            
            
            
            
            // TODO: Finish the implementation
        }
        
        return keys
    }
}
