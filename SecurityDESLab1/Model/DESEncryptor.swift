import Foundation

class DESEncryptor {
    
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
    
    private func splitMessageOnBlocks(withBitCount blockSize: Int) -> [DESBlock] {
        let bytes = getBytesFromMessage()
        let supplementedArrayOfBytes = DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: blockSize)
        
        let blockOfAllBits = DESBlock(bytes: supplementedArrayOfBytes )
        return blockOfAllBits.splittingIntoBlocks(withSize: blockSize)
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toBitCountMultiplicityOf count: Int) -> [UInt8] {
        var supplementedArray: [UInt8] = bytes
        let bitCount = bytes.count * 8
        
        let countOfBytesToSupplement = (count.getMultiple(greaterThan: bitCount) / Constants.countOfBitsInByte) - bytes.count
        
        for _ in 0..<countOfBytesToSupplement {
            supplementedArray.append(UInt8())
        }
        return supplementedArray
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toByteCountMultiplicityOf count: Int) -> [UInt8] {
        return DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: count * Constants.countOfBitsInByte)
    }
    
    private func getBytesFromMessage() -> [UInt8] {
        return [UInt8](message.utf8)
    }
}
