//
// Created by Mengyu Li on 2020/3/30.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import CLMDB

public extension Environment {
    struct Info {
        public let mapAddress: UnsafeMutableRawPointer?
        public let mapSize: Int
        public let lastPageID: Int
        public let lastTransactionID: Int
        public let maxReaders: UInt32
        public let readers: UInt32

        init(envinfo: MDB_envinfo) {
            mapAddress = envinfo.me_mapaddr
            mapSize = envinfo.me_mapsize
            lastPageID = envinfo.me_last_pgno
            lastTransactionID = envinfo.me_last_txnid
            maxReaders = envinfo.me_maxreaders
            readers = envinfo.me_numreaders
        }
    }
}
