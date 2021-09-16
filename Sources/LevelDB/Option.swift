//
// Created by Mengyu Li on 2021/9/16.
//

import CLevelDB

public class Option {
    public let createIfMissing: Bool
    public let errorIfExists: Bool
    public let paranoidChecks: Bool
    public let writeBufferSize: size_t
    public let maxOpenFiles: CInt
    public let blockSize: size_t
    public let blockRestartInterval: CInt
    public let maxFileSize: size_t

    let pointer: OpaquePointer

    public init(createIfMissing: Bool = true,
                errorIfExists: Bool = false,
                paranoidChecks: Bool = false,
                writeBufferSize: size_t = 4 * 1024 * 1024,
                maxOpenFiles: CInt = 1000,
                blockSize: size_t = 4 * 1024,
                blockRestartInterval: CInt = 16,
                maxFileSize: size_t = 2 * 1024 * 1024) {
        self.createIfMissing = createIfMissing
        self.errorIfExists = errorIfExists
        self.paranoidChecks = paranoidChecks
        self.writeBufferSize = writeBufferSize
        self.maxOpenFiles = maxOpenFiles
        self.blockSize = blockSize
        self.blockRestartInterval = blockRestartInterval
        self.maxFileSize = maxFileSize

        self.pointer = leveldb_options_create()
        leveldb_options_set_create_if_missing(self.pointer, self.createIfMissing.uint8)
        leveldb_options_set_error_if_exists(self.pointer, self.errorIfExists.uint8)
        leveldb_options_set_paranoid_checks(self.pointer, self.paranoidChecks.uint8)
        leveldb_options_set_write_buffer_size(self.pointer, self.writeBufferSize)
        leveldb_options_set_max_open_files(self.pointer, self.maxOpenFiles)
        leveldb_options_set_block_size(self.pointer, self.blockSize)
        leveldb_options_set_block_restart_interval(self.pointer, self.blockRestartInterval)
        leveldb_options_set_max_file_size(self.pointer, self.maxFileSize)
    }

    deinit {
        leveldb_options_destroy(pointer)
    }
}

public extension Option {
    static let `default` = Option()
}
