//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB
import Foundation

public class Environment {
    private(set) var pointer: OpaquePointer
    private(set) var flags: Flags

    /// Initializes a new environment instance. An environment may contain 0 or more databases.
    /// - parameter path: The path to the folder in which the environment should be created. The folder must exist and be writeable.
    /// - parameter flags: A set containing flags for the environment. See `Environment.Flags`
    /// - parameter maxDBs: The maximum number of named databases that can be opened in the environment. It is recommended to keep a "moderate amount" and not a "huge number" of databases in a given environment. Default is 0, preventing any named database from being opened.
    /// - parameter maxReaders: The maximum number of threads/reader slots. Default is 126.
    /// - parameter mapSize: The size of the memory map. The value should be a multiple of the OS page size. Default is 10485760 bytes. See http://104.237.133.194/doc/group__mdb.html#gaa2506ec8dab3d969b0e609cd82e619e5 for more.
    /// - throws: an error if operation fails. See `Error`.
    public init(path: String, flags: Flags = [], maxDBs: UInt32? = nil, maxReaders: UInt32? = nil, mapSize: size_t? = nil, fileMode: mode_t = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) throws {
        self.flags = flags

        // Prepare the environment.
        var pointerOptional: OpaquePointer?
        let envCreateStatus = mdb_env_create(&pointerOptional)
        guard envCreateStatus == 0 else { throw LMDBError(returnCode: envCreateStatus) }
        guard let pointer = pointerOptional else { throw LMDBError.nullPointer }
        self.pointer = pointer

        // Set the maximum number of named databases that can be opened in the environment.
        if let maxDBs = maxDBs {
            let envSetMaxDBsStatus = mdb_env_set_maxdbs(pointer, MDB_dbi(maxDBs))
            guard envSetMaxDBsStatus == 0 else { throw LMDBError(returnCode: envSetMaxDBsStatus) }
        }

        // Set the maximum number of threads/reader slots for the environment.
        if let maxReaders = maxReaders {
            let envSetMaxReadersStatus = mdb_env_set_maxreaders(pointer, maxReaders)
            guard envSetMaxReadersStatus == 0 else { throw LMDBError(returnCode: envSetMaxReadersStatus) }
        }

        // Set the size of the memory map.
        if let mapSize = mapSize {
            let envSetMapSizeStatus = mdb_env_set_mapsize(pointer, mapSize)
            guard envSetMapSizeStatus == 0 else { throw LMDBError(returnCode: envSetMapSizeStatus) }
        }

        // Open the environment.
//        let userAccess = flags.contains(.readOnly) ? (S_IRUSR | S_IXUSR) : S_IRWXU
//        let fileMode: mode_t = userAccess | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH

        let envOpenStatus = mdb_env_open(pointer, path.cString(using: .utf8), UInt32(flags.rawValue), fileMode)

        guard envOpenStatus == 0 else { throw LMDBError(returnCode: envOpenStatus) }
    }

    internal init(pointer: OpaquePointer) throws {
        self.pointer = pointer
        var flags: UInt32 = 0
        let ret = mdb_env_get_flags(pointer, &flags)
        guard ret == 0 else { throw LMDBError(returnCode: ret) }
        self.flags = Environment.Flags(rawValue: Int32(flags))
    }

    deinit { mdb_env_close(pointer) }
}

// MARK: - Database

public extension Environment {
    /// Opens a database in the environment.
    /// - parameter name: The name of the database or `nil` if the unnamed/anonymous database in the environment should be used.
    /// - note: The parameter `maxDBs` supplied when instantiating the environment determines how many named databases can be opened inside the environment.
    /// - throws: an error if operation fails. See `Error`.
    func openDatabase(name: String? = nil, flags: Database.Flags = [.create]) throws -> Database {
        try Database(environment: self, name: name, flags: flags)
    }
}

// MARK: - Sync

public extension Environment {
    /// Flush the data buffers to disk.
    /// - Parameter force: If true, force a synchronous flush. Otherwise if the environment has the `noSync` flag set the flushes will be omitted, and with `mapAsync` they will be asynchronous.
    func sync(force: Bool) throws {
        let result = mdb_env_sync(pointer, force ? 1 : 0)
        if result != 0 {
            throw LMDBError(returnCode: result)
        }
    }
}

public extension Environment {}

// MARK: - Info

public extension Environment {
    func info() throws -> Info {
        let env_info_p = UnsafeMutablePointer<MDB_envinfo>.allocate(capacity: MemoryLayout<MDB_envinfo>.size)
        defer { env_info_p.deallocate() }
        try Transaction(environment: self) { _ in
            let rc = mdb_env_info(pointer, env_info_p)
            guard rc == 0 else { return .abort }
            return .commit
        }
        return Info(envinfo: env_info_p.pointee)
    }

    func state() throws -> State {
        let statPointer = UnsafeMutablePointer<MDB_stat>.allocate(capacity: MemoryLayout<MDB_stat>.size)
        defer { statPointer.deallocate() }
        try Transaction(environment: self, action: { transaction -> Transaction.Action in
            mdb_env_stat(transaction.pointer, statPointer)
            return .commit
        })
        return State(stat: statPointer.pointee)
    }
}

extension Environment: Equatable {
    public static func == (lhs: Environment, rhs: Environment) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
