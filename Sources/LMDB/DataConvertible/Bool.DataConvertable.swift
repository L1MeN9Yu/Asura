//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Bool: DataConvertible {
    public init?(data: Data) {
        guard let integer = UInt8(data: data) else { return nil }
        self = (integer != 0)
    }

    public var toData: Data {
        let value: UInt8 = self ? 1 : 0
        return value.toData
    }
}
