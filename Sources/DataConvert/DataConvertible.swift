//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import struct Foundation.Data

public typealias DataConvertible = DataEncodable & DataDecodable

public protocol DataEncodable {
    func toData() throws -> Data
}

public protocol DataDecodable {
    init(data: Data) throws
}
