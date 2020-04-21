//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public protocol External {
    static func log(logFlag: LogFlag, message: CustomStringConvertible?, filename: String, function: String, line: Int)
}

var __external: External.Type?

public func register(external: External.Type?) {
    __external = external
}
