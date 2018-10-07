import Foundation

func ^(lhs: Block, rhs: Block) -> Block {
    let greater = lhs.bitsCount > rhs.bitsCount ? lhs : rhs
    let smaller = lhs.bitsCount > rhs.bitsCount ? rhs : lhs
    
    var bytes = [UInt8]()
    for byteIndex in 0..<smaller.bitsCount {
        let byte = greater.bytes[byteIndex] ^ smaller.bytes[byteIndex]
        bytes.append(byte)
    }
    return Block(bytes: bytes)
}
