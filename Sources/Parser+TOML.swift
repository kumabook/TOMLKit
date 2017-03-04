import Runes
import Result
import TryParsec

/// Parses TOML.
public func parseTOML(_ str: String) -> Result<TOMLObject, ParseError> {
    return parseOnly(toml, str.unicodeScalars)
}


// MARK: Private
internal let toml = _toml()
private func _toml() -> Parser<String.UnicodeScalarView, TOMLObject> {
    return skipSpaces *> tomlObject <* skipSpaces <* endOfInput()
}

// TODO:
internal let tomlObject = _tomlObject()
private func _tomlObject() -> Parser<String.UnicodeScalarView, TOMLObject> {
    return many(comment <|> keyValue)
      <&> { (tomls: [TOML]) in
          var obj = TOMLObject()
          for t in tomls {
              switch t {
              case .comment(_):
                  break
              case .keyValue(let key, let value):
                  obj[key] = value
              default:
                  break
              }
          }
          return obj
      }
}

internal let comment = _comment();
private func _comment() -> Parser<String.UnicodeScalarView, TOML> {
    return string("#") *> manyTill(any, string("\n"))
      <&> { .comment(String($0)) }
}


internal let keyValue = _keyValue();
private func _keyValue() -> Parser<String.UnicodeScalarView, TOML> {
    return { a in { b in TOML.keyValue(String(a), b) } }
      <^> key
      <*> (skipSpaces *> char("=") *> skipSpaces *> tomlValue <* skipSpaces)
}

internal let key = _key();
private func _key() -> Parser<String.UnicodeScalarView, String> {
    return bareKey <|> singleQuotedKey <|> doubleQuotedKey
}

internal let bareKey = _bareKey();
private func _bareKey() -> Parser<String.UnicodeScalarView, String> {
    return manyTill(alphaNum <|> oneOf("_-"), string(" ")) <&> { String($0) }
}

internal let singleQuotedKey = _singleQuotedKey();
private func _singleQuotedKey() -> Parser<String.UnicodeScalarView, String> {
    return string("'") *> manyTill(any, string("'")) <&> { String($0) }
}

internal let doubleQuotedKey = _doubleQuotedKey();
private func _doubleQuotedKey() -> Parser<String.UnicodeScalarView, String> {
    return string("\"") *> manyTill(any, string("\"")) <&> { String($0) }
}

internal let tomlValue = _tomlValue()
private func _tomlValue() -> Parser<String.UnicodeScalarView, TOMLValue> {
    return tomlString <|> tomlInteger
}

internal let tomlString = _tomlString()
private func _tomlString() -> Parser<String.UnicodeScalarView, TOMLValue> {
    return stringValue <&> { TOMLValue.string(String($0)) }
}

// MARK: TODO
internal let stringValue = _stringValue()
private func _stringValue() -> Parser<String.UnicodeScalarView, String.UnicodeScalarView> {
    let normalChar = satisfy { $0 != "\\" && $0 != "\""}
    return char("\"") *> many(normalChar) <* char("\"")
}

internal let tomlInteger = _tomlInteger()
private func _tomlInteger() -> Parser<String.UnicodeScalarView, TOMLValue> {
    return { sign in
        { value in
            TOMLValue.integer(signedValue(sign.map { String($0) }, Int(String(value))!))
        }
    } <^> (zeroOrOne(char("+") <|> char("-")))
      <*> manyTill(digit <* skipMany(satisfy(isUnderscore)), space)
}

private func signedValue(_ sign: String?, _ value: Int) -> Int {
    if let s = sign , s == "-" {
        return -value
    }
    return value
}

private let _underscore: String.UnicodeScalarView = "_"
private func isUnderscore(_ c: UnicodeScalar) -> Bool {
    return "_" == c
}
