@testable import LMDB
import XCTest

final class LMDBTests: XCTestCase {
    func testOpen() throws {
        let environment = try Environment(path: tempPath())
        XCTAssertNotNil(environment)
    }

    func testWrite() throws {
        let environment = try Environment(path: tempPath(), maxDBs: 1)
        let database = try environment.openDatabase()
        XCTAssertNotNil(environment)
        XCTAssertNotNil(database)
        let intValue = Int.random(in: Int.min..<Int.max)
        try database.put(key: "Int", value: intValue)
        try XCTAssertEqual(database.get(key: "Int"), intValue)
    }
}

private extension LMDBTests {
    func tempPath(createIfNotExist: Bool = true) throws -> String {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Asura", isDirectory: true)
            .appendingPathComponent("LMDB", isDirectory: true)
            .appendingPathComponent(
                Data(
                    (0..<6).map { _ in UInt8.random(in: UInt8.min..<UInt8.max) }
                )
                .base64EncodedString()
            )

        let path = url.path

        if createIfNotExist {
            if !FileManager.default.fileExists(atPath: path) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
        }

        return path
    }
}
