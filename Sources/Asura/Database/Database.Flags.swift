//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import CLMDB

public extension Database {
    struct Flags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) { self.rawValue = rawValue }
    }
}

public extension Database.Flags {
    static let reverseKey = Self(rawValue: MDB_REVERSEKEY)
    static let duplicateSort = Self(rawValue: MDB_DUPSORT)
    static let integerKey = Self(rawValue: MDB_INTEGERKEY)
    static let duplicateFixed = Self(rawValue: MDB_DUPFIXED)
    static let integerDuplicate = Self(rawValue: MDB_INTEGERDUP)
    static let reverseDuplicate = Self(rawValue: MDB_REVERSEDUP)
    static let create = Self(rawValue: MDB_CREATE)
}