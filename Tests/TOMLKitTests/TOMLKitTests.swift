import XCTest
@testable import TOMLKit

class TOMLKitTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(TOMLKit().text, "Hello, World!")
    }

    static var allTests : [(String, (TOMLKitTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
