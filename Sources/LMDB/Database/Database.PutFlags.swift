//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB
import Foundation

public extension Database {
    /// These flags can be passed when putting values into the database.
    struct PutFlags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) { self.rawValue = rawValue }
    }
}

public extension Database.PutFlags {
    static let noDuplicateData = Self(rawValue: MDB_NODUPDATA)
    static let noOverwrite = Self(rawValue: MDB_NOOVERWRITE)
    static let reserve = Self(rawValue: MDB_RESERVE)
    static let append = Self(rawValue: MDB_APPEND)
    static let appendDuplicate = Self(rawValue: MDB_APPENDDUP)
}
