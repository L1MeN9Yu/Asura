//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import CLMDB

public extension Environment {
    struct Flags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) { self.rawValue = rawValue }
    }
}

public extension Environment.Flags {
    static let fixedMap = Self(rawValue: MDB_FIXEDMAP)
    static let noSubDir = Self(rawValue: MDB_NOSUBDIR)
    static let noSync = Self(rawValue: MDB_NOSYNC)
    static let readOnly = Self(rawValue: MDB_RDONLY)
    static let noMetaSync = Self(rawValue: MDB_NOMETASYNC)
    static let writeMap = Self(rawValue: MDB_WRITEMAP)
    static let mapAsync = Self(rawValue: MDB_MAPASYNC)
    static let noTLS = Self(rawValue: MDB_NOTLS)
    static let noLock = Self(rawValue: MDB_NOLOCK)
    static let noReadahead = Self(rawValue: MDB_NORDAHEAD)
    static let noMemoryInit = Self(rawValue: MDB_NOMEMINIT)
}