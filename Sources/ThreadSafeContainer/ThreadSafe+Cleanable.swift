public protocol Cleanable {
  mutating func removeAll(keepingCapacity keepCapacity: Bool)
}

extension Dictionary: Cleanable {}
extension Array: Cleanable {}
extension Set: Cleanable {}

extension ThreadSafe: Cleanable where WrappedType: Cleanable {
  @inlinable public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { lockedWrite({ $0.removeAll(keepingCapacity: keepCapacity) }) }
}
