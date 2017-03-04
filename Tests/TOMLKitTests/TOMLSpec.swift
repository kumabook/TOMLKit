@testable import TOMLKit

import Foundation
import Result
import Quick
import Nimble

class TOMLSpec: QuickSpec {
    func readFile(_ path: String) -> String {
        return try! String(contentsOfFile: path, encoding: .utf8)
    }
    func readAssetsFile(_ name: String) -> String {
        return readFile("./TestAssets/\(name).toml")
    }
    override func spec() {
        describe("parseTOML") {
            context("comment") {
                it("succeeds") {
                    let string = self.readAssetsFile("comment")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [:]
                    expect(result.value!).to(equal(expected))
                }
            }
            context("keyValue") {
                it("succeeds") {
                    let string = self.readAssetsFile("key_value")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [
                      "key":                .string("value"),
                      "bare_key":           .string("value"),
                      "bare-key":           .string("value"),
                      "1234":               .string("value"),
                      "127.0.0.1":          .string("value"),
                      "character encoding": .string("value"),
                      "ʎǝʞ":                .string("value"),
                      "key2":               .string("value"),
                      "quoted \"value\"":   .string("value"),
                    ]
                    expect(result.value!).to(equal(expected))
                }
                it("fails") {
                    let string = self.readAssetsFile("key_value_invalid")
                    let result = parseTOML(string)
                    expect(result.value).to(beNil())
                }
                it("also succeeds") {
                    let string = self.readAssetsFile("key_value_discouraged")
                    let result = parseTOML(string)
                    let expected: TOMLObject = ["": .string("blank")]
                    expect(result.value!).to(equal(expected))
                }
            }
            context("integer") {
                it("succeeds") {
                    let string = self.readAssetsFile("integer")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [
                      "int1": .integer(99),
                      "int2": .integer(42),
                      "int3": .integer(0),
                      "int4": .integer(-17),
                      "int5": .integer(1000),
                      "int6": .integer(5349221),
                      "int7": .integer(12345),
                    ]
                    expect(result.value!).to(equal(expected))
                }
            }
            context("boolean") {
                it("succeeds") {
                    let string = self.readAssetsFile("boolean")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [
                      "bool1": .boolean(true),
                      "bool2": .boolean(false),
                    ]
                    expect(result.value!).to(equal(expected))
                }
            }
        }
    }
}
