//
// Created by Mengyu Li on 2021/1/11.
//

@_implementationOnly import CLMDB
import Foundation

// MARK: - Cursor

public class Cursor {
    private(set) var pointer: OpaquePointer

    public init(transaction: Transaction, database: Database) throws {
        var pointerOptional: OpaquePointer?
        let open_result = mdb_cursor_open(transaction.pointer, database.id, &pointerOptional)
        guard open_result == 0 else { throw LMDBError(returnCode: open_result) }
        guard let pointer = pointerOptional else { throw LMDBError.nullPointer }
        self.pointer = pointer
    }

    deinit { mdb_cursor_close(pointer) }
}

// MARK: - Renew

public extension Cursor {
    func renew(transaction: Transaction) throws {
        let open_result = mdb_cursor_renew(transaction.pointer, pointer)
        guard open_result == 0 else { throw LMDBError(returnCode: open_result) }
    }
}

// MARK: - Getter

public extension Cursor {
    func transaction() throws -> Transaction {
        guard let transactionPointer = mdb_cursor_txn(pointer) else { throw LMDBError.nullPointer }
        return Transaction(pointer: transactionPointer)
    }

    func database() throws -> Database {
        let id = mdb_cursor_dbi(pointer)
        let transaction = try self.transaction()
        let environment = try transaction.environment()
        let database = Database(id: id, environment: environment)
        return database
    }
}
