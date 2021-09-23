//
// Created by Mengyu Li on 2021/9/16.
//

public struct Property: RawRepresentable {
    public typealias RawValue = String
    public let rawValue: String

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

public extension Property {
    //  "leveldb.stats" - returns a multi-line string that describes statistics about the internal operation of the DB.
    static let stats: Self = Property(rawValue: "leveldb.stats")
    //  "leveldb.sstables" - returns a multi-line string that describes all of the sstables that make up the db contents.
    static let sstables: Self = Property(rawValue: "leveldb.sstables")
    /// "leveldb.approximate-memory-usage" - returns the approximate number of bytes of memory in use by the DB.
    static let approximateMemoryUsage: Self = Property(rawValue: "leveldb.approximate-memory-usage")
    /// "leveldb.num-files-at-level<N>" - return the number of files at level <N>, where <N> is an ASCII representation of a level number (e.g. "0").
    static let numFilesAtLevel: (_ level: UInt) -> Self = { level in Property(rawValue: "leveldb.num-files-at-level\(level)") }
}
