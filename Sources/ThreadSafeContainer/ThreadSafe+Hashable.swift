extension ThreadSafe: Hashable where WrappedType: Hashable {
  @inlinable public func hash(into hasher: inout Hasher) {
    lockedRead({ $0.hash(into: &hasher) })
  }
}
