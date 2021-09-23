//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB

public enum Repairer {}

public extension Repairer {
    static func repair(path: String, option: Option) throws {
        var lastErrorPtr: UnsafeMutablePointer<Int8>?
        leveldb_repair_db(option.pointer, path, &lastErrorPtr)

        if let error = lastErrorPtr {
            let message = String(cString: error)
            leveldb_free(error)
            throw LevelDBError.repair(message: message)
        }
    }
}
