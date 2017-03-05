// MARK: TOML

public typealias TOMLObject = [String : TOMLValue]
public enum TOMLValue {
    case string(String)
    case integer(Int)
    case float(Double)
    case boolean(Bool)
    case array([TOMLValue])
    case object(TOMLObject)
}

extension TOMLValue: Equatable {}
public func == (lhs: TOMLValue, rhs: TOMLValue) -> Bool
{
    switch (lhs, rhs) {
    case let (.string( l), .string( r)): return l == r
    case let (.integer(l), .integer(r)): return l == r
    case let (.float(l)  , .float(r)):   return l == r
    case let (.boolean(l), .boolean(r)): return l == r
    case let (.array(  l), .array(  r)): return l == r
    case let (.object( l), .object( r)): return l == r
    default:
        return false
    }
}

public indirect enum TOML {
    // # comment
    case comment(String)
    // key = value
    case keyValue(String, TOMLValue)
    // [key]
    case table(String, TOMLValue)
    // [[key]]
    case arrayOfTable(String, TOMLValue)
}
