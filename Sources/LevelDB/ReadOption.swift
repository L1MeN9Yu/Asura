//
// Created by Mengyu Li on 2021/9/16.
//

import CLevelDB

public class ReadOption {
    let pointer: OpaquePointer

    public var verifyChecksum: Bool {
        didSet {
            leveldb_readoptions_set_verify_checksums(pointer, verifyChecksum.uint8)
        }
    }

    public var fillCache: Bool {
        didSet {
            leveldb_readoptions_set_fill_cache(pointer, fillCache.uint8)
        }
    }

    public var snapshot: Snapshot? {
        didSet {
            leveldb_readoptions_set_snapshot(pointer, snapshot?.pointer)
        }
    }

    public init(verifyChecksum: Bool = false, fillCache: Bool = false) {
        pointer = leveldb_readoptions_create()

        self.verifyChecksum = verifyChecksum
        self.fillCache = fillCache

        leveldb_readoptions_set_verify_checksums(pointer, verifyChecksum.uint8)
        leveldb_readoptions_set_fill_cache(pointer, fillCache.uint8)
    }

    deinit {
        leveldb_readoptions_destroy(pointer)
    }
}

public extension ReadOption {
    static let `default` = ReadOption()
}
