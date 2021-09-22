import XCTest

final class DataConvertTests: XCTestCase {
    func testStringCount() {
        let common = "common"
        let emoji = "👼"
        XCTAssertEqual(common.utf8.count, 6)
        XCTAssertEqual(emoji.utf8.count, 4)
    }
}
