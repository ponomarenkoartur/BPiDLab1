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
    
    func testBlockSubscript() {
        var block = Block(bytes: [0b10101010, 0b01010101])
        XCTAssert(block[0] == .one)
        XCTAssert(block[1] == .zero)
        XCTAssert(block[15] == .one)
        XCTAssert(block[10] == .zero)
        XCTAssert(block[16] == nil)
        XCTAssert(block[-1] == nil)
        
        block = Block(bytes: [0b10101010, 0b11101111], bitsCount: 12)!
        XCTAssert(block[0] == .zero)
        
        block[0] = .one
        XCTAssert(block == Block(bytes: [0b10101010, 0b11110000], bitsCount: 12)!)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
