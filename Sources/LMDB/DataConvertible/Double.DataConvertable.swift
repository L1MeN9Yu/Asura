//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

extension Double: DataConvertible {
    public init?(data: Data) {
        guard data.count == MemoryLayout<UInt64>.size else { return nil }
        let littleEndian = data.withUnsafeBytes { $0.load(as: UInt64.self) }
        let bitPattern = UInt64(littleEndian: littleEndian)
        self = .init(bitPattern: bitPattern)
    }

    public var toData: Data {
        let littleEndian = bitPattern.littleEndian
        return withUnsafePointer(to: littleEndian) { pointer -> Data in
            Data(buffer: UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
