//
// Created by Mengyu Li on 2021/9/16.
//

extension Bool {
    var uint8: UInt8 {
        switch self {
        case true:
            return 1
        case false:
            return 0
        }
    }
}