//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Date: DataConvertible {
    public init?(data: Data) {
        guard let timeInterval = TimeInterval(data: data) else { return nil }
        self = Date(timeIntervalSinceReferenceDate: timeInterval)
    }

    public var toData: Data {
        self.timeIntervalSinceReferenceDate.toData
    }
}
