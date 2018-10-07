import Foundation

public class Block {
    
    // MARK: Properties
    
    private var bytes: [UInt8]
    private(set) var bitsCount: Int
    
    private var iterationsCount = 0
    
    // MARK: - Copmuted Properties
    
    
    var leftPart: Block {
        return Block(bytes: Array(bytes[0..<(bytes.count / 2)]))
    }
    
    var rightPart: Block {
        return Block(bytes: Array(bytes[(bytes.count / 2)..<bytes.count]))
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
            for bitIndex in 0..<block.bitsCount {
                self[globalBitIndex] = self[bitIndex]
                globalBitIndex += 1
            }
        }
    }
    
    // MARK: Subscript
    
    subscript(index: Int) -> BitValue? {
        get {
            guard index >= 0, index < bitsCount else {
                return nil
            }
            
            let byte = bytes[index / Constants.countOfBitsInByte]
            let bitIndexInByte = index % Constants.countOfBitsInByte
            
            let bit = (byte >> bitIndexInByte) & 1
            return bit == 1 ? .one : .zero
        }
        set {
            guard index >= 0, let newValue = newValue, (newValue.rawValue == 1 || newValue.rawValue == 0) else { return }
            
            if index > bitsCount {
                self.supplement(toBitCount: index)
            }
            
            var byte = bytes[index / Constants.countOfBitsInByte]
            let bitIndexInByte = index % Constants.countOfBitsInByte
            
            switch newValue {
            case .one:
                byte = byte | (0b00000001 << bitIndexInByte)
            case .zero:
                byte = byte & (0b11111110 << bitIndexInByte)
            }
            
            bytes[index / Constants.countOfBitsInByte] = byte
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
        guard iterationsCount<bitsCount else {
            return nil
        }
        iterationsCount += 1
        
        return self[iterationsCount]
    }
}

extension Block: Equatable {
    public static func == (lhs: Block, rhs: Block) -> Bool {
        if lhs.bitsCount != rhs.bitsCount {
            return false
        }
        
        for bitIndex in 0..<lhs.bitsCount {
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

