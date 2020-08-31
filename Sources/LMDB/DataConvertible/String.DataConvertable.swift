//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension String: DataConvertible {
    public init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }

    public var toData: Data { data(using: .utf8)! }
}
