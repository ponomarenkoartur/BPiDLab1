//
//  SecurityDESLab1Tests.swift
//  SecurityDESLab1Tests
//
//  Created by Artur on 10/7/18.
//  Copyright © 2018 Artur. All rights reserved.
//

import XCTest

class SecurityDESLab1Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBlockEquality() {
        XCTAssert(Block(bytes: [0b10100101, 0b01011010]) == Block(bytes: [0b10100101, 0b01011010]))
        XCTAssert(Block(bytes: [0b10100101]) == Block(bytes: [0b10100101]))
        XCTAssert(Block(bytes: [0b10100101, 0b01010000], bitsCount: 12) == Block(bytes: [0b10100101, 0b01011111], bitsCount: 12))
        XCTAssert(Block(bytes: [0b11111111, 0b11111111, 0b11110000], bitsCount: 20) == Block(bytes: [0b11111111, 0b11111111, 0b11111111], bitsCount: 20))
    }
    
    func testBlockGetSubscript() {
        var block = Block(bytes: [0b10101010, 0b10101010])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .zero)
        XCTAssert(block[15] == .zero)
        XCTAssert(block[7] == .zero)
        XCTAssert(block[8] == .one)
        XCTAssert(block[16] == nil)
        XCTAssert(block[-1] == nil)
        
        block = Block(bytes: [0b10101010])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .zero)
        XCTAssert(block[7] == .zero)
    }

    func testBlockSetSubscript() {
        var block = Block(bytes: [0b00010000, 0b11101111], bitsCount: 12)!
        block[0] = .one
        block[8] = .zero
        XCTAssert(block[0] == .one)
        XCTAssert(block[8] == .zero)
        
        block = Block(bytes: [0b00000000])
        block[0] = .one
        block[3] = .one
        block[7] = .one
        XCTAssert(block[0] == .one)
        XCTAssert(block[3] == .one)
        XCTAssert(block[7] == .one)
        XCTAssert(block == Block(bytes: [0b10010001]))
        
        block = Block(bytes: [0b11110000])
        block[4] = .one
        XCTAssert(block == Block(bytes: [0b11111000]))
    }
    
    func testBlockRangeSubscript() {
        let block = Block(bytes: [0b00000000, 0b11111111])
        let slice = block[3..<11]
        print(slice)
        XCTAssert(slice == Block(bytes: [0b00000111]))
    }
    
    func testBlockClosedRangeSubscript() {
        let block = Block(bytes: [0b00000000, 0b11111111])
        let slice = block[3...10]
        print(slice)
        XCTAssert(slice == Block(bytes: [0b00000111]))
    }
    
    func testBlockLeftPartAndRightPart() {
        var block = Block(bytes: [0b00000000, 0b11111111])
        XCTAssert(block.leftPart == Block(bytes: [0b00000000]))
        XCTAssert(block.rightPart == Block(bytes: [0b11111111]))
        
        block = Block(bytes: [0b00000001, 0b11111100], bitsCount: 14)!
        
        XCTAssert(block.leftPart == Block(bytes: [0b00000000], bitsCount: 7))
        XCTAssert(block.rightPart == Block(bytes: [0b11111110], bitsCount: 7))
    }
    
    func testDESBlockCycleShifted() {
        let block = Block(bytes: [0b00000000, 0b11111111])
        XCTAssert(block <<< 4 == Block(bytes: [0b00001111, 0b11110000]), "Block is: \(block)")
        XCTAssert(block >>> 4 == Block(bytes: [0b11110000, 0b00001111]), "Block is: \(block)")
        XCTAssert(block >>> 8 == Block(bytes: [0b11111111, 0b00000000]), "Block is: \(block)")
    }
    
    func testKeyGeneratorGetKeys() {
        let initialKey = DESBlock(bytes: [0b00110001, 0b00110010, 0b00110011, 0b00110100, 0b00110101, 0b00110110, 0b00110111, 0b00111000])
        let keyGenerator = KeyGenerator(initialKey: initialKey)
    }
    
    func testDESBlockPermutated() {
        var block = DESBlock(bytes: [0b00110001])
        var permutationTable = [8, 7, 6, 5, 4, 3, 2, 1]
        var permutated = block.permutated(withPermutationTable: permutationTable)!
        XCTAssert(permutated == DESBlock(bytes: [0b10001100]))
        
        permutationTable = [8, 7, 6, 5, 4, 3, 2, 1, 8, 7, 6, 5, 4, 3, 2, 1]
        permutated = block.permutated(withPermutationTable: permutationTable)!
        XCTAssert(permutated == DESBlock(bytes: [0b10001100, 0b10001100]))
        
        block = DESBlock(bytes: [0b00110001, 0b00110001])
        permutationTable = [1, 2, 3, 4, 5, 6, 7, 8]
        permutated = block.permutated(withPermutationTable: permutationTable)!
        XCTAssert(permutated == DESBlock(bytes: [0b00110001]))
        
        block = DESBlock(bytes: [0b00110001, 0b00110010, 0b00110011, 0b00110100, 0b00110101, 0b00110110, 0b00110111, 0b00111000])
        permutated = block.permutated(withPermutationTable: DESTable.initialKeyPermutation)!
        XCTAssert(permutated == DESBlock(bytes: [0b00000000, 0b00000000, 0b11111111, 0b11110110, 0b01100111, 0b10001000, 0b00001111]))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
