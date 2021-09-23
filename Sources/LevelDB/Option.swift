//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
import typealias Darwin.C.stddef.size_t
#elseif os(Linux)
import Glibc
#else
#error("not support")
#endif

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

        pointer = leveldb_options_create()
        leveldb_options_set_create_if_missing(pointer, self.createIfMissing.uint8)
        leveldb_options_set_error_if_exists(pointer, self.errorIfExists.uint8)
        leveldb_options_set_paranoid_checks(pointer, self.paranoidChecks.uint8)
        leveldb_options_set_write_buffer_size(pointer, self.writeBufferSize)
        leveldb_options_set_max_open_files(pointer, self.maxOpenFiles)
        leveldb_options_set_block_size(pointer, self.blockSize)
        leveldb_options_set_block_restart_interval(pointer, self.blockRestartInterval)
        leveldb_options_set_max_file_size(pointer, self.maxFileSize)
    }

    deinit {
        leveldb_options_destroy(pointer)
    }
}

public extension Option {
    static let `default` = Option()
}
