import Foundation

public class Block {
    
    // MARK: Properties
    
    private(set) var bytes: [UInt8]
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

    
    // MARK: Methods
    
    public func getBit(atIndex index: Int) -> BitValue? {
        guard index >= 0, index < bitsCount else {
            return nil
        }
        
        let byte = bytes[index / Constants.countOfBitsInByte]
        let bitIndexInByte = index % Constants.countOfBitsInByte
        
        let bit = (byte >> bitIndexInByte) & 1
        return bit == 1 ? .one : .zero
    }
    
    public func setBit(atIndex index: Int, toValue value: BitValue) {
        guard index >= 0, (value.rawValue == 1 || value.rawValue == 0) else {
            return
        }
        
        if index > bitsCount {
            self.supplement(toBitCount: index)
        }
        
        var byte = bytes[index / Constants.countOfBitsInByte]
        let bitIndexInByte = index % Constants.countOfBitsInByte
        
        switch value {
        case .one:
            byte = byte | (0b00000001 << bitIndexInByte)
        case .zero:
            byte = byte & (0b11111110 << bitIndexInByte)
        }
        
        bytes[index / Constants.countOfBitsInByte] = byte
    }
    
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

public enum BitValue: UInt8, CustomStringConvertible {
    case zero = 0
    case one = 1
    
    public var description: String {
        return self == .one ? "1" : "0"
    }
}

extension Block: Sequence, IteratorProtocol {
    public func next() -> BitValue?{
        guard iterationsCount<bitsCount else {
            return nil
        }
        iterationsCount += 1
        
        return self.getBit(atIndex: iterationsCount)
    }
}

