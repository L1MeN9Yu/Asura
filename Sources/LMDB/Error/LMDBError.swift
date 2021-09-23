//
// Created by Mengyu Li on 2020/3/29.
// Copyright (c) 2020 Mengyu Li. All rights reserved.
//

@_implementationOnly import CLMDB
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
import var Darwin.C.errno.EPERM
import var Darwin.C.errno.ENOENT
import var Darwin.C.errno.EINVAL
import var Darwin.C.errno.ENOSPC
import var Darwin.C.errno.ENOMEM
import var Darwin.C.errno.EIO
import var Darwin.C.errno.EACCES
#elseif os(Linux)
import Glibc
#else
#error("not support")
#endif

public enum LMDBError: Error {
    // LMDB defined errors.
    case keyExists
    case notFound
    case pageNotFound
    case corrupted
    case panic
    case versionMismatch
    case invalid
    case mapFull
    case dbsFull
    case readersFull
    case tlsFull
    case txnFull
    case cursorFull
    case pageFull
    case mapResized
    case incompatible
    case badReaderSlot
    case badTransaction
    case badValueSize
    case badDBI

    // OS errors
    case operationNotPermitted
    case noSuchFileOrDirectory
    case invalidParameter
    case outOfDiskSpace
    case outOfMemory
    case ioError
    case accessViolation

    // FFI Error
    case nullPointer

    case other(returnCode: Int32)

    init(returnCode: Int32) {
        switch returnCode {
        case MDB_KEYEXIST: self = .keyExists
        case MDB_NOTFOUND: self = .notFound
        case MDB_PAGE_NOTFOUND: self = .pageNotFound
        case MDB_CORRUPTED: self = .corrupted
        case MDB_PANIC: self = .panic
        case MDB_VERSION_MISMATCH: self = .versionMismatch
        case MDB_INVALID: self = .invalid
        case MDB_MAP_FULL: self = .mapFull
        case MDB_DBS_FULL: self = .dbsFull
        case MDB_READERS_FULL: self = .readersFull
        case MDB_TLS_FULL: self = .tlsFull
        case MDB_TXN_FULL: self = .txnFull
        case MDB_CURSOR_FULL: self = .cursorFull
        case MDB_PAGE_FULL: self = .pageFull
        case MDB_MAP_RESIZED: self = .mapResized
        case MDB_INCOMPATIBLE: self = .incompatible
        case MDB_BAD_RSLOT: self = .badReaderSlot
        case MDB_BAD_TXN: self = .badTransaction
        case MDB_BAD_VALSIZE: self = .badValueSize
        case MDB_BAD_DBI: self = .badDBI

        case EPERM: self = .operationNotPermitted
        case ENOENT: self = .noSuchFileOrDirectory
        case EINVAL: self = .invalidParameter
        case ENOSPC: self = .outOfDiskSpace
        case ENOMEM: self = .outOfMemory
        case EIO: self = .ioError
        case EACCES: self = .accessViolation

        default: self = .other(returnCode: returnCode)
        }
    }
}

extension LMDBError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .keyExists:
            return String(cString: mdb_strerror(MDB_KEYEXIST))
        case .notFound:
            return String(cString: mdb_strerror(MDB_NOTFOUND))
        case .pageNotFound:
            return String(cString: mdb_strerror(MDB_PAGE_NOTFOUND))
        case .corrupted:
            return String(cString: mdb_strerror(MDB_CORRUPTED))
        case .panic:
            return String(cString: mdb_strerror(MDB_PANIC))
        case .versionMismatch:
            return String(cString: mdb_strerror(MDB_VERSION_MISMATCH))
        case .invalid:
            return String(cString: mdb_strerror(MDB_INVALID))
        case .mapFull:
            return String(cString: mdb_strerror(MDB_MAP_FULL))
        case .dbsFull:
            return String(cString: mdb_strerror(MDB_DBS_FULL))
        case .readersFull:
            return String(cString: mdb_strerror(MDB_READERS_FULL))
        case .tlsFull:
            return String(cString: mdb_strerror(MDB_TLS_FULL))
        case .txnFull:
            return String(cString: mdb_strerror(MDB_TXN_FULL))
        case .cursorFull:
            return String(cString: mdb_strerror(MDB_CURSOR_FULL))
        case .pageFull:
            return String(cString: mdb_strerror(MDB_PAGE_FULL))
        case .mapResized:
            return String(cString: mdb_strerror(MDB_MAP_RESIZED))
        case .incompatible:
            return String(cString: mdb_strerror(MDB_INCOMPATIBLE))
        case .badReaderSlot:
            return String(cString: mdb_strerror(MDB_BAD_RSLOT))
        case .badTransaction:
            return String(cString: mdb_strerror(MDB_BAD_TXN))
        case .badValueSize:
            return String(cString: mdb_strerror(MDB_BAD_VALSIZE))
        case .badDBI:
            return String(cString: mdb_strerror(MDB_BAD_DBI))
        case .operationNotPermitted:
            return String(cString: mdb_strerror(EPERM))
        case .noSuchFileOrDirectory:
            return String(cString: mdb_strerror(ENOENT))
        case .invalidParameter:
            return String(cString: mdb_strerror(EINVAL))
        case .outOfDiskSpace:
            return String(cString: mdb_strerror(ENOSPC))
        case .outOfMemory:
            return String(cString: mdb_strerror(ENOMEM))
        case .ioError:
            return String(cString: mdb_strerror(EIO))
        case .accessViolation:
            return String(cString: mdb_strerror(EACCES))
        case .nullPointer:
            return "POINTER RETURN NULL"
        case .other(returnCode: let returnCode):
            let possible = String(cString: mdb_strerror(returnCode))
            switch possible.isEmpty {
            case true:
                return "UNKNOWN ERROR : \(returnCode)"
            case false:
                return possible
            }
        }
    }
}
