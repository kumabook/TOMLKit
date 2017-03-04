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
            }
        }
    }
}
