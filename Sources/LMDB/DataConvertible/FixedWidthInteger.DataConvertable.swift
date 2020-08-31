//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension FixedWidthInteger where Self: DataConvertible {
    public init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        let littleEndian = data.withUnsafeBytes { $0.load(as: Self.self) }
        self = .init(littleEndian: littleEndian)
    }

    public var toData: Data {
        let littleEndian = self.littleEndian
        return withUnsafePointer(to: littleEndian) { (pointer) -> Data in
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
