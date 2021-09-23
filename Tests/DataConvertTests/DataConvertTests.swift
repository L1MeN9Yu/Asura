import XCTest
@testable import DataConvert

final class DataConvertTests: XCTestCase {
    func testStringCount() {
        let common = "common"
        let emoji = "👼"
        XCTAssertEqual(common.utf8.count, 6)
        XCTAssertEqual(emoji.utf8.count, 4)
    }

    func testString() throws {
        let string = "common 👼"
        let data = try string.toData()
        XCTAssertEqual(data.count, string.utf8.count)
        let decodeString = try String(data: data)
        XCTAssertEqual(string, decodeString)
    }
}
