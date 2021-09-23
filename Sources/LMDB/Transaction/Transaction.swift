//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB
import Foundation

/// All read and write operations on the database happen inside a Transaction.
public struct Transaction {
    private(set) var pointer: OpaquePointer

    /// Creates a new instance of Transaction and runs the closure provided.
    /// Depending on the result returned from the closure, the transaction will either be comitted or aborted.
    /// If an error is thrown from the transaction closure, the transaction is aborted.
    /// - parameter environment: The environment with which the transaction will be associated.
    /// - parameter parent: Transactions can be nested to unlimited depth. (WARNING: Not yet tested)
    /// - parameter flags: A set containing flags modifying the behavior of the transaction.
    /// - parameter closure: The closure in which database interaction should occur. When the closure returns, the transaction is ended.
    /// - throws: an error if operation fails. See `Error`.
    @discardableResult
    init(environment: Environment, parent: Transaction? = nil, flags: Flags = [], action: (Transaction) throws -> Transaction.Action) throws {
        var flags = flags
        if environment.flags.contains(.readOnly) { flags.insert(.readOnly) }
        // http://lmdb.tech/doc/group__mdb.html#gad7ea55da06b77513609efebd44b26920
        var pointerOptional: OpaquePointer?
        let txnStatus = mdb_txn_begin(environment.pointer, parent?.pointer, UInt32(flags.rawValue), &pointerOptional)
        guard txnStatus == 0 else { throw LMDBError(returnCode: txnStatus) }
        guard let pointer = pointerOptional else { throw LMDBError.nullPointer }
        self.pointer = pointer

        // Run the closure inside a do/catch block, so we can abort the transaction if an error is thrown from the closure.
        do {
            let transactionResult = try action(self)
            switch transactionResult {
            case .abort:
                mdb_txn_abort(pointer)
            case .commit:
                let commitStatus = mdb_txn_commit(pointer)
                guard commitStatus == 0 else { throw LMDBError(returnCode: commitStatus) }
            }
        } catch {
            mdb_txn_abort(pointer)
            throw error
        }
    }

    internal init(pointer: OpaquePointer) {
        self.pointer = pointer
    }
}

extension Transaction {
    func environment() throws -> Environment {
        guard let environmentPointer = mdb_txn_env(pointer) else { throw LMDBError.nullPointer }
        return try Environment(pointer: environmentPointer)
    }
}

extension Transaction: Equatable {
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.pointer == rhs.pointer
    }
}
