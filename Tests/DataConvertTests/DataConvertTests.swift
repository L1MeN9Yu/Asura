import XCTest
@testable import DataConvert

final class DataConvertTests: XCTestCase {
    func testStringCount() {
        let common = "common"
        let emoji = "👼"
        XCTAssertEqual(common.utf8.count, 6)
        XCTAssertEqual(emoji.utf8.count, 4)
    }

    func testBool() throws {
        let bool = false
        let data = try bool.toData()
        XCTAssertEqual(data.count, 1)
        let decodeBool = try Bool(data: data)
        XCTAssertEqual(bool, decodeBool)
    }

    func testData() throws {
        let data = Data([UInt8]([0x00, 0x01, 0x02]))
        let encodeData = try data.toData()
        XCTAssertEqual(data, encodeData)
        let decodeData = try Data(data: encodeData)
        XCTAssertEqual(data, decodeData)
    }

    func testDate() throws {
        let date = Date()
        let data = try date.toData()
        XCTAssertEqual(data.count, MemoryLayout<UInt64>.size)
        let decodeDate = try Date(data: data)
        XCTAssertEqual(date, decodeDate)
    }

    func testDouble() throws {
        let double = Double.random(in: Double.leastNonzeroMagnitude..<Double.leastNormalMagnitude)
        let data = try double.toData()
        XCTAssertEqual(data.count, MemoryLayout<UInt64>.size)
        let decodeDouble = try Double(data: data)
        XCTAssertEqual(double, decodeDouble)
    }

    func testFixedWidthInteger() throws {
        let uint64 = UInt64.random(in: .min ..< .max)
        let data = try uint64.toData()
        XCTAssertEqual(data.count, MemoryLayout<UInt64>.size)
        let decodeUint64 = try UInt64(data: data)
        XCTAssertEqual(uint64, decodeUint64)
    }

    func testFloat() throws {
        let float = Float.random(in: Float.leastNonzeroMagnitude..<Float.leastNormalMagnitude)
        let data = try float.toData()
        XCTAssertEqual(data.count, MemoryLayout<UInt32>.size)
        let decodeFloat = try Float(data: data)
        XCTAssertEqual(float, decodeFloat)
    }

    func testString() throws {
        let string = "common 👼"
        let data = try string.toData()
        XCTAssertEqual(data.count, string.utf8.count)
        let decodeString = try String(data: data)
        XCTAssertEqual(string, decodeString)
    }
}
