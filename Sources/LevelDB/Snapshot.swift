//
// Created by Mengyu Li on 2021/9/16.
//

@_implementationOnly import CLevelDB

public class Snapshot {
    let pointer: OpaquePointer
    let databasePointer: OpaquePointer

    public init(database: Database) {
        databasePointer = database.pointer
        pointer = leveldb_create_snapshot(databasePointer)
    }

    deinit {
        leveldb_release_snapshot(databasePointer, pointer)
    }
}
