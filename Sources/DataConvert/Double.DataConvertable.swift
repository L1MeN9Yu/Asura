//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import struct Foundation.Data

extension Double: DataConvertible {
    public init(data: Data) throws {
        guard data.count == MemoryLayout<UInt64>.size else {
            throw DataConvertError.doubleDecode
        }
        let littleEndian = data.withUnsafeBytes { $0.load(as: UInt64.self) }
        let bitPattern = UInt64(littleEndian: littleEndian)
        self = .init(bitPattern: bitPattern)
    }

    public func toData() throws -> Data {
        let littleEndian = bitPattern.littleEndian
        return withUnsafePointer(to: littleEndian) { pointer -> Data in
            Data(buffer: UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
