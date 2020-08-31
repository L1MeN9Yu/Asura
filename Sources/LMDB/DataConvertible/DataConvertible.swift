//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

import Foundation

/// Any type conforming to the DataConvertible protocol can be used as both key and value in LMDB.
/// The protocol provides a default implementation, which will work for most Swift value types.
/// For other types, including reference counted ones, you may want to implement the conversion yourself.
public protocol DataConvertible {
    init?(data: Data)
    var toData: Data { get }
}
