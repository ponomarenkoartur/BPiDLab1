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
        XCTAssert(Block(bytes: [0b10100101, 0b01010000], bitsCount: 12) == Block(bytes: [0b10100101, 0b01011111], bitsCount: 12))
        XCTAssert(Block(bytes: [0b11111111, 0b11111111, 0b1110000], bitsCount: 20) == Block(bytes: [0b11111111, 0b11111111, 0b11111111], bitsCount: 20))
    }
    
    func testBlockGetSubscript() {
        let block = Block(bytes: [0b10101011, 0b01010101])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .zero)
        XCTAssert(block[15] == .one)
        XCTAssert(block[7] == .zero)
        XCTAssert(block[8] == .one)
        XCTAssert(block[16] == nil)
        XCTAssert(block[-1] == nil)
    }

    func testBlockSetSubscript() {
        let block = Block(bytes: [0b00010000, 0b11101111], bitsCount: 12)!
        block[0] = .one
        block[8] = .zero
        XCTAssert(block[0] == .one)
        XCTAssert(block[8] == .zero)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
