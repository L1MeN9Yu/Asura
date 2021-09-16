//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB

public extension Transaction {
    struct Flags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
    }
}

public extension Transaction.Flags {
    static let readOnly = Self(rawValue: MDB_RDONLY)
}
