//
// Created by Mengyu Li on 2020/3/30.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation
import Asura_LMDB

public struct State {
    public let pageSize: UInt32
    public let depth: UInt32
    public let branchPages: Int
    public let leafPages: Int
    public let overflowPages: Int
    public let entries: Int

    init(stat: MDB_stat) {
        pageSize = stat.ms_psize
        depth = stat.ms_depth
        branchPages = stat.ms_branch_pages
        leafPages = stat.ms_leaf_pages
        overflowPages = stat.ms_overflow_pages
        entries = stat.ms_entries
    }
}
