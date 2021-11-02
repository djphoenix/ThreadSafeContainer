public protocol KeyValue {
  associatedtype Key
  associatedtype Value
  subscript (_ key: Key) -> Value? { get set }
}

public protocol GetOrCreateValue: KeyValue {
  mutating func getOrCreate(_ key: Key, create: (() throws -> Value)) rethrows -> Value
}

public extension GetOrCreateValue {
  subscript (_ key: Key, create: (() throws -> Value)) -> Value {
    @inlinable mutating get throws { try getOrCreate(key, create: create) }
  }
  subscript (_ key: Key, create: (() -> Value)) -> Value {
    @inlinable mutating get { getOrCreate(key, create: create) }
  }
}

extension Dictionary: KeyValue {}

extension ThreadSafe: KeyValue, GetOrCreateValue where WrappedType: KeyValue {
  public typealias Key = WrappedType.Key
  public typealias Value = WrappedType.Value

  public subscript(key: Key) -> Value? {
    @inlinable get { lockedRead({ $0[key] }) }
    @inlinable set { lockedWrite({ $0[key] = newValue }) }
  }

  @inlinable public mutating func getOrCreate(_ key: Key, create: (() throws -> Value)) rethrows -> Value {
    if let value = lockedRead({ $0[key] }) { return value }
    return try lockedWrite({
      if let value = $0[key] { return value }
      let value = try create()
      $0[key] = value
      return value
    })
  }
}
