//
// Created by Mengyu Li on 2020/3/30.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import CLMDB

public enum Version {}

public extension Version {
    static let string = {
        "\(major).\(minor).\(patch)"
    }()

    static let major = {
        MDB_VERSION_MAJOR
    }()

    static let minor = {
        MDB_VERSION_MINOR
    }()

    static let patch = {
        MDB_VERSION_PATCH
    }()

    static let date = {
        MDB_VERSION_DATE
    }()
}
