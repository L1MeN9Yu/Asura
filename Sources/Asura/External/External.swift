//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public struct External { private init() {} }

public extension External {
    typealias Log = (_ logFlag: LogFlag, _ message: CustomStringConvertible?, _ filename: String, _ function: String, _ line: Int) -> Void
}

public extension External {
    static var log: Log? = nil

    static func register(log: Log?) {
        self.log = log
    }
}