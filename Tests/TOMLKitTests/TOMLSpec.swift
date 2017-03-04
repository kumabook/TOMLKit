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
                    let tomlString = self.readFile("./TestAssets/comment.toml")
                    let result = parseTOML(tomlString)
                    expect(result.value!).to(equal(.comment("comment")))
                }
            }
        }
    }
}
