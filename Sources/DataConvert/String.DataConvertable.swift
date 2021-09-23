//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension String: DataConvertible {
    public init(data: Data) throws {
        guard let value = String(data: data, encoding: .utf8) else {
            throw DataConvertError.stringDecode
        }
        self = value
    }

    public func toData() throws -> Data {
        guard let data = data(using: .utf8) else {
            throw DataConvertError.stringEncode
        }
        return data
    }
}
