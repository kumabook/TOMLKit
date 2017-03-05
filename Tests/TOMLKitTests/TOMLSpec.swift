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
                    expect(result.value).notTo(beNil())
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
                    expect(result.value).notTo(beNil())
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
                    expect(result.value).notTo(beNil())
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
                    expect(result.value).notTo(beNil())
                    expect(result.value!).to(equal(expected))
                }
            }
            context("float") {
                it("succeeds") {
                    let string = self.readAssetsFile("float")
                    let result = parseTOML(string)
                    let expected: TOMLObject = [
                      "flt1": .float(+1.0),
                      "flt2": .float(3.1415),
                      "flt3": .float(-0.01),
                      "flt4": .float(5e+22),
                      "flt5": .float(1e6),
                      "flt6": .float(-2E-2),
                      "flt7": .float(6.626e-34),
                    ]
                    expect(result.value).notTo(beNil())
                    let actual = result.value!
                    for (key, value) in expected {
                        if case let (.float(a), .float(e)) = (actual[key]!, value) {
                            expect(a).to(beCloseTo(e))
                        }
                    }
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
                    expect(result.value).notTo(beNil())
                    expect(result.value!).to(equal(expected))
                }
            }
        }
    }
}
