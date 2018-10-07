import Foundation

func ^(lhs: Block, rhs: Block) -> Block {
    let greater = lhs.bitCount > rhs.bitCount ? lhs : rhs
    let smaller = lhs.bitCount > rhs.bitCount ? rhs : lhs
    
    var bytes = [UInt8]()
    for byteIndex in 0..<smaller.bitCount {
        let byte = greater.bytes[byteIndex] ^ smaller.bytes[byteIndex]
        bytes.append(byte)
    }
    return Block(bytes: bytes)
}
