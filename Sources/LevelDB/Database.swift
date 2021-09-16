//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB
import struct Foundation.Data

public class Database {

    let path: String

    let pointer: OpaquePointer

    private let writeOption: WriteOption
    private let readOption: ReadOption
    private var lastErrorPtr: UnsafeMutablePointer<Int8>? = nil

    public init(path: String, option: Option = .default, writeOption: WriteOption = .default, readOption: ReadOption = .default) throws {
        self.path = path

        guard let pointer = leveldb_open(option.pointer, path, &lastErrorPtr) else {
            var message: String? = nil
            if let error = lastErrorPtr {
                message = String(cString: error)
            }
            throw LevelDBError.open(message: message)
        }

        self.pointer = pointer
        self.writeOption = writeOption
        self.readOption = readOption
    }

    deinit {
        leveldb_close(pointer)
        if let e = lastErrorPtr {
            leveldb_free(e)
        }
    }
}

public extension Database {
    func put(key: String, value: Data) throws {
        try value.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Int8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                throw LevelDBError.put(message: nil)
            }

            leveldb_put(pointer, writeOption.pointer, key, key.count, unsafePointer, value.count, &lastErrorPtr)

            if let error = lastErrorPtr {
                let message = String(cString: error)
                throw LevelDBError.put(message: message)
            }
        }
    }

    func get(key: String) throws -> Data? {
        var valueLength: Int = 0
        guard let dataPtr = leveldb_get(pointer, readOption.pointer, key, key.count, &valueLength, &lastErrorPtr) else {
            if let error = lastErrorPtr {
                let message = String(cString: error)
                throw LevelDBError.get(message: message)
            }
            return nil
        }
        defer {
            dataPtr.deallocate()
        }
        let data = Data(bytes: dataPtr, count: valueLength)
        return data
    }

    func delete(key: String) throws {
        leveldb_delete(pointer, writeOption.pointer, key, key.count, &lastErrorPtr)
        if let error = lastErrorPtr {
            let message = String(cString: error)
            throw LevelDBError.delete(message: message)
        }
    }

    func writeBatch(_ batch: WriteBatch) throws {
        leveldb_write(pointer, writeOption.pointer, batch.pointer, &lastErrorPtr)
        if let error = lastErrorPtr {
            let message = String(cString: error)
            throw LevelDBError.writeBatch(message: message)
        }
    }

    func iterator(reverse: Bool = false, startKey: String? = nil, action: (_ key: String, _ value: Data, _ stop: inout Bool) -> Void) throws {
        let iterator = leveldb_create_iterator(pointer, readOption.pointer)
        defer { leveldb_iter_destroy(iterator) }

        let `init` = {
            if let startKey = startKey {
                leveldb_iter_seek(iterator, startKey, startKey.count)
            } else {
                switch reverse {
                case true:
                    leveldb_iter_seek_to_last(iterator)
                case false:
                    leveldb_iter_seek_to_first(iterator)
                }
            }
        }
        let go = {
            switch reverse {
            case true:
                leveldb_iter_prev(iterator)
            case false:
                leveldb_iter_next(iterator)
            }
        }

        `init`()
        while leveldb_iter_valid(iterator) != 0 {
            var keyLength = 0
            var valueLength = 0
            if let keyPtr = leveldb_iter_key(iterator, &keyLength),
               let valuePtr = leveldb_iter_value(iterator, &valueLength) {
                let keyData = Data(bytes: keyPtr, count: keyLength)
                let value = Data(bytes: valuePtr, count: valueLength)
                if let key = String(data: keyData, encoding: .utf8) {
                    var stop: Bool = false
                    action(key, value, &stop)

                    if stop { break }
                }
            }
            go()
        }

        leveldb_iter_get_error(iterator, &lastErrorPtr)
        if let error = lastErrorPtr {
            let message = String(cString: error)
            throw LevelDBError.iterator(message: message)
        }
    }
}

public extension Database {
    func getProperty(_ property: Property) -> String? {
        guard let value = leveldb_property_value(pointer, property.rawValue) else { return nil }
        defer { leveldb_free(value) }
        return String(cString: value)
    }
}

public extension Database {
    func compact(beginKey: String? = nil, endKey: String? = nil) {
        leveldb_compact_range(pointer, beginKey, beginKey?.count ?? 0, endKey, endKey?.count ?? 0)
    }
}
