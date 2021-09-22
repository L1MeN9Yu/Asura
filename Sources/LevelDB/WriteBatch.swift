//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB
import struct Foundation.Data

public class WriteBatch {
    let pointer: OpaquePointer

    public init() {
        pointer = leveldb_writebatch_create()
    }

    public init(pointer: OpaquePointer) {
        self.pointer = pointer
    }

    deinit {
        leveldb_writebatch_destroy(pointer)
    }
}

public extension WriteBatch {
    func put(key: String, value: Data) throws {
        try value.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Int8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                throw LevelDBError.put(message: nil)
            }
            leveldb_writebatch_put(pointer, key, key.utf8.count, unsafePointer, value.count)
        }
    }

    func delete(key: String) {
        leveldb_writebatch_delete(pointer, key, key.utf8.count)
    }

    func clear() {
        leveldb_writebatch_clear(pointer)
    }
}

public extension WriteBatch {
    static func +(lhs: WriteBatch, rhs: WriteBatch) -> WriteBatch {
        let pointer: OpaquePointer = leveldb_writebatch_create()
        leveldb_writebatch_append(pointer, lhs.pointer)
        leveldb_writebatch_append(pointer, rhs.pointer)
        return WriteBatch(pointer: pointer)
    }
}
