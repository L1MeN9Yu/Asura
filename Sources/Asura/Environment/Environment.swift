//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import CLMDB

public class Environment {
    internal private(set) var pointer: OpaquePointer?
    internal private(set) var flags: Flags

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
        let envCreateStatus = mdb_env_create(&pointer)

        guard envCreateStatus == 0 else { throw Error(returnCode: envCreateStatus) }

        // Set the maximum number of named databases that can be opened in the environment.
        if let maxDBs = maxDBs {
            let envSetMaxDBsStatus = mdb_env_set_maxdbs(pointer, MDB_dbi(maxDBs))
            guard envSetMaxDBsStatus == 0 else { throw Error(returnCode: envSetMaxDBsStatus) }
        }

        // Set the maximum number of threads/reader slots for the environment.
        if let maxReaders = maxReaders {
            let envSetMaxReadersStatus = mdb_env_set_maxreaders(pointer, maxReaders)
            guard envSetMaxReadersStatus == 0 else { throw Error(returnCode: envSetMaxReadersStatus) }
        }

        // Set the size of the memory map.
        if let mapSize = mapSize {
            let envSetMapSizeStatus = mdb_env_set_mapsize(pointer, mapSize)
            guard envSetMapSizeStatus == 0 else { throw Error(returnCode: envSetMapSizeStatus) }
        }

        // Open the environment.
//        let userAccess = flags.contains(.readOnly) ? (S_IRUSR | S_IXUSR) : S_IRWXU
//        let fileMode: mode_t = userAccess | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH

        let envOpenStatus = mdb_env_open(pointer, path.cString(using: .utf8), UInt32(flags.rawValue), fileMode)

        guard envOpenStatus == 0 else { throw Error(returnCode: envOpenStatus) }
    }

    deinit {
        // Close the handle when environment is deallocated.
        mdb_env_close(pointer)
    }
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

// MARK: - Info
public extension Environment {
    var info: Info? {
        let env_info_p = UnsafeMutablePointer<MDB_envinfo>.allocate(capacity: MemoryLayout<MDB_envinfo>.size)
        defer { env_info_p.deallocate() }
        do {
            try Transaction(environment: self) { transaction in
                let rc = mdb_env_info(pointer, env_info_p)
                guard rc == 0 else { return .abort }
                return .commit
            }
            return Info(envinfo: env_info_p.pointee)
        } catch {
            Logger.error(message: "\(error)")
            return nil
        }
    }

    var state: State? {
        let statPointer = UnsafeMutablePointer<MDB_stat>.allocate(capacity: MemoryLayout<MDB_stat>.size)
        defer { statPointer.deallocate() }
        do {
            try Transaction(environment: self, action: { transaction -> Transaction.Action in
                mdb_env_stat(transaction.pointer, statPointer)
                return .commit
            })
            return State(stat: statPointer.pointee)
        } catch {
            Logger.error(message: "\(error)")
            return nil
        }
    }
}
