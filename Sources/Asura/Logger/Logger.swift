//
// Created by Mengyu Li on 2020/1/20.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

struct Logger { private init() {} }

private extension Logger {
    static func log(flag: LogFlag, message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        __external?.log(logFlag: flag, message: message, filename: filename, function: function, line: line)
    }
}

extension Logger {
    static func trace(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .trace, message: message, filename: filename, function: function, line: line)
    }

    static func debug(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .debug, message: message, filename: filename, function: function, line: line)
    }

    static func info(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .info, message: message, filename: filename, function: function, line: line)
    }

    static func warn(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .warn, message: message, filename: filename, function: function, line: line)
    }

    static func error(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .error, message: message, filename: filename, function: function, line: line)
    }

    static func crit(message: CustomStringConvertible?, filename: String = #file, function: String = #function, line: Int = #line) {
        log(flag: .crit, message: message, filename: filename, function: function, line: line)
    }
}
