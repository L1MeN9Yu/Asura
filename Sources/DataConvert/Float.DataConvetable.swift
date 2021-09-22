//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Float: DataConvertible {
    public init(data: Data) throws {
        guard data.count == MemoryLayout<UInt32>.size else {
            throw DataConvertError.floatDecode
        }
        let littleEndian = data.withUnsafeBytes { $0.load(as: UInt32.self) }
        let bitPattern = UInt32(littleEndian: littleEndian)
        self = .init(bitPattern: bitPattern)
    }

    public func toData() throws -> Data {
        let littleEndian = bitPattern.littleEndian
        return withUnsafePointer(to: littleEndian) { (pointer) -> Data in
            Data(buffer: UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
