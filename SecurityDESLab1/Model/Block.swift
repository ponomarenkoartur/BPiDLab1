import Foundation

let COUNT_OF_BITS_IN_BYTE: Int = 8

public class Block {
    
    // MARK: Properties
    
    private(set) var bytes: [UInt8]
    
    // MARK: - Copmuted Properties
    
    var bitCount: Int {
        return bytes.count * COUNT_OF_BITS_IN_BYTE
    }
    
    var leftPart: Block {
        return Block(bytes: Array(bytes[0..<(bytes.count / 2)]))
    }
    
    var rightPart: Block {
        return Block(bytes: Array(bytes[(bytes.count / 2)..<bytes.count]))
    }

    // MARK: - Initialization
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    // MARK: Methods
    
    public func getBit(atPosition position: Int) -> UInt8? {
        guard position >= 0, position < bytes.count * COUNT_OF_BITS_IN_BYTE else {
            return nil
        }
        
        let byte = bytes[position / COUNT_OF_BITS_IN_BYTE]
        let bitPositionInByte = position % COUNT_OF_BITS_IN_BYTE
        
        return (byte >> bitPositionInByte) & 1
    }
    
    public func setBit(atPosition position: Int, toValue value: UInt8) {
        guard position >= 0, position < bytes.count * COUNT_OF_BITS_IN_BYTE, (value == 1 || value == 0) else {
            return
        }
        
        var byte = bytes[position / COUNT_OF_BITS_IN_BYTE]
        let bitPositionInByte = position % COUNT_OF_BITS_IN_BYTE
        
        if value == 1 {
            byte = byte | (0b00000001 << bitPositionInByte)
        } else {
            byte = byte & (0b11111110 << bitPositionInByte)
        }
        
        bytes[position / COUNT_OF_BITS_IN_BYTE] = byte
    }
}
