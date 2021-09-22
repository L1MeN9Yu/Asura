//
// Created by Mengyu Li on 2021/9/17.
//

public enum DataConvertError: Error {
    case stringEncode
    case stringDecode
    case doubleEncode
    case doubleDecode
    case floatEncode
    case floatDecode
    case fixedWidthIntegerEncode
    case fixedWidthIntegerDecode
}
