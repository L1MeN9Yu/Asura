//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Data: DataConvertible {
    public init?(data: Data) { self = data }

    public var toData: Data { self }
}
