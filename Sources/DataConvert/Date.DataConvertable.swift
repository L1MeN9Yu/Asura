//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import struct Foundation.Date
import struct Foundation.Data
import struct Foundation.TimeInterval

extension Date: DataConvertible {
    public init(data: Data) throws {
        let timeInterval = try TimeInterval(data: data)
        self = Date(timeIntervalSinceReferenceDate: timeInterval)
    }

    public func toData() throws -> Data {
        try timeIntervalSinceReferenceDate.toData()
    }
}
