//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import struct Foundation.Data

extension Bool: DataConvertible {
    public init(data: Data) throws {
        let integer = try UInt8(data: data)
        self = (integer != 0)
    }

    public func toData() throws -> Data {
        let value: UInt8 = self ? 1 : 0
        return try value.toData()
    }
}
