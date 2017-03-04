@testable import TOMLKit

import Foundation
import Result
import Quick
import Nimble

class TOMLSpec: QuickSpec {
    func readFile(_ path: String) -> String {
        return try! String(contentsOfFile: path, encoding: .utf8)
    }
    override func spec() {
        describe("parseTOML") {
            context("comment") {
                it("succeeds") {
                    let string = self.readFile("./TestAssets/comment.toml")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [:]
                    expect(result.value!).to(equal(expected))
                }
            }
            context("keyValue") {
                it("succeeds") {
                    let string = self.readFile("./TestAssets/key_value.toml")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [
                      "key1": .string("value1"),
                      "key2": .string("value2"),
                      "key3": .string("value3"),
                    ]
                    expect(result.value!).to(equal(expected))
                }
            }
        }
    }
}
