//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB
import Foundation

/// A database contained in an environment.
/// The database can either be named (if maxDBs > 0 on the environment) or
/// it can be the single anonymous/unnamed database inside the environment.
public class Database {
    private(set) var id: MDB_dbi = 0
    private let environment: Environment

    /// - throws: an error if operation fails. See `Error`.
    init(environment: Environment, name: String?, flags: Flags = []) throws {
        self.environment = environment

        try Transaction(environment: environment) { transaction -> Transaction.Action in
            let openStatus = mdb_dbi_open(transaction.pointer, name?.cString(using: .utf8), UInt32(flags.rawValue), &id)
            guard openStatus == 0 else { throw LMDBError(returnCode: openStatus) }

            // Commit the open transaction.
            return .commit
        }
    }

    init(id: MDB_dbi, environment: Environment) {
        self.id = id
        self.environment = environment
    }

    deinit {
        // Close the database.
        // http://lmdb.tech/doc/group__mdb.html#ga52dd98d0c542378370cd6b712ff961b5
        mdb_dbi_close(environment.pointer, id)
    }
}

// MARK: - CURD

public extension Database {
    /// Returns a value from the database instantiated as type `V` for a key of type `K`.
    /// - parameter type: A type conforming to `DataConvertible` that you want to be instantiated with the value from the database.
    /// - parameter key: A key conforming to `DataConvertible` for which the value will be looked up.
    /// - returns: Returns the value as an instance of type `V` or `nil` if no value exists for the key or the type could not be instatiated with the data.
    /// - note: You can always use `Foundation.Data` as the type. In such case, `nil` will only be returned if there is no value for the key.
    /// - throws: an error if operation fails. See `Error`.
    func get<V: DataDecodable, K: DataEncodable>(key: K) throws -> V? {
        var keyData = try key.toData()
        return try keyData.withUnsafeMutableBytes { keyBufferPointer -> V? in
            let keyPointer = keyBufferPointer.baseAddress
            var keyVal = MDB_val(mv_size: keyBufferPointer.count, mv_data: keyPointer)

            // The database will manage the memory for the returned value.
            // http://104.237.133.194/doc/group__mdb.html#ga8bf10cd91d3f3a83a34d04ce6b07992d
            var dataValue = MDB_val()
            var getStatus: Int32 = 0
            try Transaction(environment: environment, flags: .readOnly) { transaction -> Transaction.Action in
                getStatus = mdb_get(transaction.pointer, id, &keyVal, &dataValue)
                return .commit
            }

            guard getStatus != MDB_NOTFOUND else { return nil }
            guard getStatus == 0 else { throw LMDBError(returnCode: getStatus) }
            let data = Data(bytes: dataValue.mv_data, count: dataValue.mv_size)

            return try V(data: data)
        }
    }

    /// Check if a value exists for the given key.
    /// - parameter key: The key to check for.
    /// - returns: `true` if the database contains a value for the key. `false` otherwise.
    /// - throws: an error if operation fails. See `Error`.
    func exists<K: DataEncodable>(key: K) throws -> Bool {
        let data: Data? = try get(key: key)
        return data != nil
    }

    /// Inserts a value into the database.
    /// - parameter value: The value to be put into the database. The value must conform to `DataConvertible`.
    /// - parameter key: The key which the data will be associated with. The key must conform to `DataConvertible`. Passing an empty key will cause an error to be thrown.
    /// - parameter flags: An optional set of flags that modify the behavior if the put operation. Default is [] (empty set).
    /// - throws: an error if operation fails. See `Error`.
    func put<V: DataEncodable, K: DataEncodable>(key: K, value: V, flags: PutFlags = []) throws {
        var keyData = try key.toData()
        var valueData = try value.toData()

        try keyData.withUnsafeMutableBytes { keyBufferPointer in
            let keyPointer = keyBufferPointer.baseAddress
            var keyVal = MDB_val(mv_size: keyBufferPointer.count, mv_data: keyPointer)

            try valueData.withUnsafeMutableBytes { valueBufferPointer in
                let valuePointer = valueBufferPointer.baseAddress
                var valueVal = MDB_val(mv_size: valueBufferPointer.count, mv_data: valuePointer)

                var putStatus: Int32 = 0

                try Transaction(environment: self.environment) { transaction -> Transaction.Action in
                    putStatus = mdb_put(transaction.pointer, self.id, &keyVal, &valueVal, UInt32(flags.rawValue))
                    return .commit
                }

                guard putStatus == 0 else { throw LMDBError(returnCode: putStatus) }
            }
        }
    }

    /// Deletes a value from the database.
    /// - parameter key: The key identifying the database entry to be deleted. The key must conform to `DataConvertible`. Passing an empty key will cause an error to be thrown.
    /// - throws: an error if operation fails. See `Error`.
    func deleteValue<K: DataEncodable>(forKey key: K) throws {
        var keyData = try key.toData()
        try keyData.withUnsafeMutableBytes { keyBufferPointer in
            let keyPointer = keyBufferPointer.baseAddress
            var keyVal = MDB_val(mv_size: keyBufferPointer.count, mv_data: keyPointer)
            try Transaction(environment: environment) { transaction -> Transaction.Action in
                mdb_del(transaction.pointer, id, &keyVal, nil)
                return .commit
            }
        }
    }

    /// Empties the database, removing all key/value pairs.
    /// The database remains open after being emptied and can still be used.
    /// - throws: an error if operation fails. See `Error`.
    func empty() throws {
        var dropStatus: Int32 = 0
        try Transaction(environment: environment) { transaction -> Transaction.Action in
            dropStatus = mdb_drop(transaction.pointer, id, 0)
            return .commit
        }

        guard dropStatus == 0 else { throw LMDBError(returnCode: dropStatus) }
    }

    /// Drops the database, deleting it (along with all it's contents) from the environment.
    /// - warning: Dropping a database also closes it. You may no longer use the database after dropping it.
    /// - seealso: `empty()`
    /// - throws: an error if operation fails. See `Error`.
    func drop() throws {
        var dropStatus: Int32 = 0
        try Transaction(environment: environment) { transaction -> Transaction.Action in
            dropStatus = mdb_drop(transaction.pointer, id, 1)
            return .commit
        }
        guard dropStatus == 0 else { throw LMDBError(returnCode: dropStatus) }
    }
}

// MARK: - Info

public extension Database {
    func state() throws -> State {
        let statPointer = UnsafeMutablePointer<MDB_stat>.allocate(capacity: MemoryLayout<MDB_stat>.size)
        defer { statPointer.deallocate() }
        try Transaction(environment: environment, action: { transaction -> Transaction.Action in
            mdb_stat(transaction.pointer, id, statPointer)
            return .commit
        })
        return State(stat: statPointer.pointee)
    }

    /// The number of entries contained in the database.
    func count() throws -> Int {
        try state().entries
    }
}

extension Database: Equatable {
    public static func == (lhs: Database, rhs: Database) -> Bool {
        lhs.environment.pointer == rhs.environment.pointer && lhs.id == rhs.id
    }
}
