//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB

public class WriteOption {
    let pointer: OpaquePointer

    public var sync: Bool {
        didSet {
            leveldb_writeoptions_set_sync(pointer, sync.uint8)
        }
    }

    public init(sync: Bool = false) {
        pointer = leveldb_writeoptions_create()

        self.sync = sync
        leveldb_writeoptions_set_sync(pointer, sync.uint8)
    }

    deinit {
        leveldb_writeoptions_destroy(pointer)
    }
}

public extension WriteOption {
    static let `default` = WriteOption()
}
