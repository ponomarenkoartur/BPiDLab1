import Foundation

class DESEncryptor {
    
    // MARK: - Properties
    
    var message: String {
        didSet {
            blocks = splitMessageOnBlocks(withBitCount: 64)
        }
    }
    var keyPhrase: String {
        didSet {
            keys = getKeys()
        }
    }
    private lazy var blocks = splitMessageOnBlocks(withBitCount: 64)
    private lazy var encryptedBlocks = getEncryptedBlocks()
    private lazy var decryptedBlocks = getDecryptedBlocks()
    private lazy var keys = getKeys()
    
    // MARK: Initialization
    
    init(message: String, keyPhrase: String) {
        self.keyPhrase = keyPhrase
        self.message = message
    }
    
    // MARK: - Methods
    
    func encryptMessage() -> String {
        return encryptedBlocks.compactMap { $0.convertToString(encoding: .utf8) }.reduce("") { $0 + $1 }
    }
    
    func decryptMessage() -> String {
        return decryptedBlocks.compactMap { $0.convertToString(encoding: .utf8) }.reduce("") { $0 + $1 }
    }
    
    // MARK: - Private methods
    
    private func getKeys() -> [DESBlock]? {
        let keyPhraseBytes = DESEncryptor.getBytes(fromString: keyPhrase)
        guard let initialKey = DESBlock(bytes: keyPhraseBytes, bitsCount: 64) else {
            return nil
        }
        let keyGenerator = KeyGenerator(initialKey: initialKey)
        return keyGenerator?.getKeys()
    }
    
    private func getEncryptedBlocks() -> [DESBlock] {
        return blocks.compactMap { $0.encrypted(withKeys: keys!) }
    }
    
    private func getDecryptedBlocks() -> [DESBlock] {
        return encryptedBlocks.compactMap { $0.decrypted(withKeys: keys!) }
    }
    
    private func splitMessageOnBlocks(withBitCount blockSize: Int) -> [DESBlock] {
        let bytes = DESEncryptor.getBytes(fromString: self.message)
        let supplementedArrayOfBytes = DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: blockSize)
        let blockOfAllBits = DESBlock(bytes: supplementedArrayOfBytes )
        return blockOfAllBits.splittingIntoBlocks(withSize: blockSize)
    }
    
    // MARK: - Static Methods
    
    private static func getBytes(fromString string: String) -> [UInt8] {
        return [UInt8](string.utf8)
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toBitCountMultiplicityOf countMultiplicity: Int) -> [UInt8] {
        var supplementedArray: [UInt8] = bytes
        let bitCount = bytes.count * 8
        
        let countOfBytesToSupplement = (countMultiplicity.getMultiple(greaterThan: bitCount) / Constants.countOfBitsInByte) - bytes.count
        
        for _ in 0..<countOfBytesToSupplement {
            supplementedArray.append(UInt8())
        }
        return supplementedArray
    }
    
    private static func supplementArrayOfBytes(_ bytes: [UInt8], toByteCountMultiplicityOf count: Int) -> [UInt8] {
        return DESEncryptor.supplementArrayOfBytes(bytes, toBitCountMultiplicityOf: count * Constants.countOfBitsInByte)
    }
}
