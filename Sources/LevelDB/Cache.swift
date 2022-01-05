//
// Created by Mengyu Li on 2021/9/23.
//

@_implementationOnly import CLevelDB

public class Cache {
    let pointer: OpaquePointer

    public init(type: Type) {
        switch type {
        case .lru(let capacity):
            pointer = leveldb_cache_create_lru(capacity)
        }
    }

    deinit {
        leveldb_cache_destroy(pointer)
    }
}

public extension Cache {
    enum `Type` {
        // bytes
        case lru(capacity: Int)
    }
}
