import Foundation

public class Block {
    
    // MARK: Properties
    
    private var bytes: [UInt8]
    private(set) var bitsCount: Int
    
    private var iterationsCount = 0
    
    // MARK: - Copmuted Properties
    
    
    var leftPart: Block {
        return self[(bitsCount / 2)..<bitsCount]
    }
    
    var rightPart: Block {
        return self[0..<(bitsCount / 2)]
    }

    // MARK: - Initialization
    
    public init(bytes: [UInt8]) {
        self.bytes = bytes
        self.bitsCount = bytes.count * Constants.countOfBitsInByte
    }
    
    
    public init?(bytes: [UInt8], bitsCount: Int) {
        guard bitsCount <= bytes.count * Constants.countOfBitsInByte else { return nil }
        self.bitsCount = bitsCount
        let bytesCount = Block.getCountOfBytesToContain(bitsCount: bitsCount)
        self.bytes = [UInt8](bytes[0..<bytesCount])
    }
    
    public init(bitsCount: Int) {
        self.bitsCount = bitsCount
        let bytesCount = Block.getCountOfBytesToContain(bitsCount: bitsCount)
        self.bytes = [UInt8](repeating: 0, count: bytesCount)
    }

    public convenience init(block: Block) {
        self.init(bytes: block.bytes)
    }
    
    public convenience init(blocks: [Block]) {
        let bitsCount = blocks.reduce(0) { $0 + $1.bitsCount }
        self.init(bitsCount: bitsCount)
        
        var globalBitIndex = 0
        for block in blocks {
            for bit in block {
                self[globalBitIndex] = bit
                globalBitIndex += 1
            }
        }
    }
    
    // MARK: Subscript
    
    subscript(index: Int) -> BitValue? {
        get {
            guard index >= 0, index < bitsCount else { return nil }
            
            let fullBitCount = bytes.count * Constants.countOfBitsInByte
            let countOfNotUsedBitInLastByte = fullBitCount - bitsCount
            
            let byteIndex = (fullBitCount - index - countOfNotUsedBitInLastByte - 1) / Constants.countOfBitsInByte
            let bitIndexInByte = (index + countOfNotUsedBitInLastByte) % Constants.countOfBitsInByte
            
            let byte = bytes[byteIndex]
            let bit = (byte >> bitIndexInByte) & 1
            return bit == 1 ? .one : .zero
        }
        set {
            guard index >= 0, index < bitsCount, let newValue = newValue, (newValue.rawValue == 1 || newValue.rawValue == 0) else { fatalError("INDEX OUT OF RANGE") }
            
            let fullBitCount = bytes.count * Constants.countOfBitsInByte
            let countOfNotUsedBitInLastByte = fullBitCount - bitsCount
            
            let byteIndex = (fullBitCount - index - countOfNotUsedBitInLastByte - 1) / Constants.countOfBitsInByte
            let bitIndexInByte = (index + countOfNotUsedBitInLastByte) % Constants.countOfBitsInByte

            var byte = bytes[byteIndex]
            switch newValue {
            case .one:
                byte = byte | (0b00000001 << bitIndexInByte)
            case .zero:
                byte = byte & ~UInt8(0b00000001 << bitIndexInByte)
            }
            
            bytes[byteIndex] = byte
        }
    }
    
    subscript(range: Range<Int>) -> Block {
        get {
            let block = Block(bitsCount: range.count)
            for j in range {
                block[j - range.startIndex] = self[j]
            }
            return block
        }
        set {
            for j in range {
                self[j - range.startIndex] = newValue[j]
            }
        }
    }

    subscript(closedRange: ClosedRange<Int>) -> Block {
        get {
            return self[Range(closedRange)]
        }
        set {
            self[Range(closedRange)] = newValue
        }
    }

    
    // MARK: Methods
    
    private func supplement(toBitCount bitsCount: Int) {
        let countOfBytesToSupplement = bytes.count - Block.getCountOfBytesToContain(bitsCount: bitsCount)
        let newBytes = [UInt8](repeating: 0, count: countOfBytesToSupplement)
        bytes.append(contentsOf: newBytes)
    }
    
    // Static Methods
    
    private static func getCountOfBytesToContain(bitsCount: Int) -> Int {
        return Int((Float(bitsCount) / Float(Constants.countOfBitsInByte)).rounded(.up))
    }
}

extension Block: Sequence, IteratorProtocol {
    public func next() -> BitValue?{
        guard iterationsCount < bitsCount else {
            iterationsCount = 0
            return nil
        }
        let bit = self[iterationsCount]
        iterationsCount += 1
        return bit
    }
}

extension Block: Equatable {
    public static func == (lhs: Block, rhs: Block) -> Bool {
        if lhs.bitsCount != rhs.bitsCount {
            return false
        }
        
        if lhs === rhs { return true }
        
        // Compare all bytes except last
        for byteIndex in 0..<(lhs.bytes.count - 1) {
            if lhs.bytes[byteIndex] != rhs.bytes[byteIndex] { return false }
        }
        
        // Compare bits of the last byte
        for bitIndex in ((lhs.bytes.count - 1) * Constants.countOfBitsInByte)..<lhs.bitsCount {
            if lhs[bitIndex] != rhs[bitIndex] { return false }
        }
        return true
    }
    
    public static func ^(lhs: Block, rhs: Block) -> Block {
        let greater = lhs.bitsCount > rhs.bitsCount ? lhs : rhs
        let smaller = lhs.bitsCount > rhs.bitsCount ? rhs : lhs
        
        var bytes = [UInt8]()
        for byteIndex in 0..<smaller.bitsCount {
            let byte = greater.bytes[byteIndex] ^ smaller.bytes[byteIndex]
            bytes.append(byte)
        }
        return Block(bytes: bytes)
    }

}

extension Block: CustomStringConvertible {
    public var description: String {
        var description = ""
        for bitIndex in 0..<bitsCount {
            description += "\(self[bitIndex]!)"
        }
        return String(description.reversed())
    }
}

