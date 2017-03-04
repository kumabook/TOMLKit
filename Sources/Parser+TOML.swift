import Runes
import Result
import TryParsec

/// Parses TOML.
public func parseTOML(_ str: String) -> Result<TOML, ParseError> {
    return parseOnly(toml, str.unicodeScalars)
}


// MARK: Private
internal let toml = _toml()
private func _toml() -> Parser<String.UnicodeScalarView, TOML> {
    return skipSpaces *> tomlValue <* skipSpaces <* endOfInput()
}

internal let tomlValue = _tomlValue()
private func _tomlValue() -> Parser<String.UnicodeScalarView, TOML> {
    return comment
}

internal let comment = _comment();
private func _comment() -> Parser<String.UnicodeScalarView, TOML> {
    return string("#") *> manyTill(any, string("\n"))
      <&> { .comment(String($0)) }
}

