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
        XCTAssert(Block(bytes: [0b11111111, 0b11111111, 0b1110000], bitsCount: 20) == Block(bytes: [0b11111111, 0b11111111, 0b11111111], bitsCount: 20))
    }
    
    func testBlockGetSubscript() {
        var block = Block(bytes: [0b10101011, 0b01010101])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .zero)
        XCTAssert(block[15] == .one)
        XCTAssert(block[7] == .zero)
        XCTAssert(block[8] == .one)
        XCTAssert(block[16] == nil)
        XCTAssert(block[-1] == nil)
        block = Block(bytes: [0b10101011])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .one)
        XCTAssert(block[7] == .one)
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
        XCTAssert(block == Block(bytes: [0b10001001]))
        
        block = Block(bytes: [0b00001111])
        block[4] = .one
        XCTAssert(block == Block(bytes: [0b00011111]))
    }
    
    func testBlockRangeSubscript() {
        let block = Block(bytes: [0b00000000, 0b11111111])
        let slice = block[4..<12]
        print(slice)
        XCTAssert(slice == Block(bytes: [0b00001111]))
    }
    
    func testBlockClosedRangeSubscript() {
        let block = Block(bytes: [0b00000000, 0b11111111])
        let slice = block[4...11]
        print(slice)
        XCTAssert(slice == Block(bytes: [0b00001111]))
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
        XCTAssert((block <<< 4) == Block(bytes: [0b00001111, 0b11110000]))
        XCTAssert((block >>> 4) == Block(bytes: [0b11110000, 0b00001111]))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
