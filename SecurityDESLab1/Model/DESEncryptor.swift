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
            blocks = splitMessage(message, onBlocksWithByteCount: 8)
        }
    }
    
    lazy var blocks = splitMessage(message, onBlocksWithByteCount: 8)
    private let keys: [String] = []
    
    // MARK: Initialization
    
    init(message: String) {
        self.message = message
    }
    
    // MARK: - Methods
    
    func encryptMessage() -> String {
        return String(message.reversed())
    }
    
    func decryptMessage() -> String {
        return message
    }
    
    // MARK: - Static Methods
    
    private func splitMessage(_ message: String, onBlocksWithByteCount blockSize: Int) -> [Block] {
        var blocks: [Block] = []
        let bytes = getBytesFromMessage()
        let supplementedArrayOfBytes = DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: blockSize)
        
        for i in 0..<(supplementedArrayOfBytes.count / 8) {
            let blockBytes = Array(supplementedArrayOfBytes[i..<(i+blockSize)])
            blocks.append(Block(bytes: blockBytes))
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
}
