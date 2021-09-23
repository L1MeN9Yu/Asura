//
// Created by Mengyu Li on 2021/9/16.
//

public enum LevelDBError: Error {
    case open(message: String?)
    case writeOption
    case readOption
    case put(message: String?)
    case get(message: String?)
    case delete(message: String?)
    case writeBatch(message: String?)
    case iterator(message: String?)
    case repair(message: String?)
}
