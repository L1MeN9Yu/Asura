//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

public extension FixedWidthInteger where Self: DataConvertible {
    init(data: Data) throws {
        guard data.count == MemoryLayout<Self>.size else {
            throw DataConvertError.fixedWidthIntegerDecode
        }
        let littleEndian = data.withUnsafeBytes { $0.load(as: Self.self) }
        self = .init(littleEndian: littleEndian)
    }

    func toData() throws -> Data {
        let littleEndian = littleEndian
        return withUnsafePointer(to: littleEndian) { pointer -> Data in
            Data(buffer: UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}

extension Int: DataConvertible {}

extension Int8: DataConvertible {}

extension Int16: DataConvertible {}

extension Int32: DataConvertible {}

extension Int64: DataConvertible {}

extension UInt: DataConvertible {}

extension UInt8: DataConvertible {}

extension UInt16: DataConvertible {}

extension UInt32: DataConvertible {}

extension UInt64: DataConvertible {}
