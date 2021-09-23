//
// Created by Mengyu Li on 2021/9/16.
//

@testable import LevelDB
import XCTest

final class LevelDBTests: XCTestCase {
    func testOpen() throws {
        let database = try Database(path: tempPath())
        XCTAssertNotNil(database)
    }

    func testWrite() throws {
        let database = try Database(path: tempPath())
        XCTAssertNotNil(database)
        let intValue = Int.random(in: Int.min..<Int.max)
        try database.put(key: "Int", value: intValue)
        try XCTAssertEqual(database.get(key: "Int"), intValue)
    }
}

private extension LevelDBTests {
    func tempPath(createIfNotExist: Bool = true) throws -> String {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("Asura", isDirectory: true)
            .appendingPathComponent("levelDB", isDirectory: true)
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
