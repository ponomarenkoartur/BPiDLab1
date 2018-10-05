import Foundation

class DESEncryptor {
    
    // MARK: - Constants
    
    static let countOfBitsInByte = 8
    static let initialPermutationTable = [
        58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17, 9,  1, 59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7
    ]
    
    // MARK: - Properties
    
    var message: String {
        didSet {
            blocksCache = nil
        }
    }
    private var blocksCache: [Block]?
    var blocks: [Block] {
        get {
            if let blocksCache = blocksCache {
                return blocksCache
            } else {
                return splitMessage(message, onBlocksWithByteCount: 8)
            }
        }
        set {
            blocksCache = newValue
        }
    }
    private let keys: [String] = []
    
    // MARK: Initialization
    
    init(message: String) {
        self.message = message
    }
    
    // MARK: - Methods
    
    func encryptMessage() -> String {
        makeInitialPermutation()
        return String(message.reversed())
    }
    
    func decryptMessage() -> String {
        return message
    }
    
    private func makeInitialPermutation() {
        for (blockIndex, block) in blocks.enumerated() {
            guard let newBlock = Block(bytes: [UInt8](repeating: 0, count: 8)) else {
                print("Permutation can't be made")
                return
            }
            for bitPositionInBlock in 0..<block.bitCount {
                let positionInIPTable = DESEncryptor.initialPermutationTable[bitPositionInBlock] - 1
                let newBitValue = block.getBit(atPosition: positionInIPTable)
                newBlock.setBit(atPosition: bitPositionInBlock, toValue: newBitValue!)
            }
            blocks[blockIndex] = newBlock
        }
    }
    
    // MARK: - Static Methods
    
    private func splitMessage(_ message: String, onBlocksWithByteCount blockSize: Int) -> [Block] {
        var blocks: [Block] = []
        let bytes = getBytesFromMessage()
        let supplementedArrayOfBytes = DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: blockSize)
        
        for i in 0..<(supplementedArrayOfBytes.count / 8) {
            let blockBytes = Array(supplementedArrayOfBytes[i..<(i+blockSize)])
            if let block = Block(bytes: blockBytes) {
                blocks.append(block)
            } else {
                print("Can't create Block from array of bytes")
            }
        }
        
        return blocks
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toBitCountMultiplicityOf count: Int) -> [UInt8] {
        var supplementedArray: [UInt8] = bytes
        let bitCount = bytes.count * 8
        
        let countOfBytesToSupplement = (count.getMultiple(greaterThan: bitCount) / DESEncryptor.countOfBitsInByte) - bytes.count
        
        for _ in 0..<countOfBytesToSupplement {
            supplementedArray.append(UInt8())
        }
        return supplementedArray
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toByteCountMultiplicityOf count: Int) -> [UInt8] {
        return DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: count * countOfBitsInByte)
    }
    
    private func getBytesFromMessage() -> [UInt8] {
        return [UInt8](message.utf8)
    }
    
    private static func encryptBlock(_ block: Block, withKeys keys: [Int]) {
        var leftPart = block.leftPart()
        var rightPart = block.rightPart()
        
        guard leftPart != nil, rightPart != nil else {
            print("Can't split block on two parts")
            return
        }
        
        for j in 0..<16 {
            let block = leftPart! ^ makeFerstailFunc(forBlock: rightPart!, andKey: keys[j])
            leftPart = rightPart
            rightPart = block
        }
    }
    
    private static func makeFerstailFunc(forBlock block: Block, andKey key: Int) -> Block {
        // TODO: Implement function
        return Block(bytes: [UInt8](repeating: 0, count: 64))!
    }
}
