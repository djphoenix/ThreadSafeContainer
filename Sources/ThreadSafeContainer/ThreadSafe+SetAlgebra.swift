extension ThreadSafe: SetAlgebra, ExpressibleByArrayLiteral where WrappedType: SetAlgebra, WrappedType.ArrayLiteralElement == WrappedType.Element {
  @inlinable public init() { self.init(wrappedValue: .init()) }
  @inlinable public init(arrayLiteral elements: WrappedType.Element...) { self.init(wrappedValue: .init(elements)) }
  @inlinable public init<S: Sequence>(_ sequence: S) where S.Element == WrappedType.Element { self.init(wrappedValue: .init(sequence)) }

  @inlinable public func contains(_ member: WrappedType.Element) -> Bool { lockedRead({ $0.contains(member) }) }
  @discardableResult
  @inlinable public mutating func insert(_ newMember: WrappedType.Element) -> (inserted: Bool, memberAfterInsert: WrappedType.Element) { lockedWrite({ $0.insert(newMember) }) }
  @discardableResult
  @inlinable public mutating func update(with newMember: WrappedType.Element) -> WrappedType.Element? { lockedWrite({ $0.update(with: newMember) }) }
  @discardableResult
  @inlinable public mutating func remove(_ member: WrappedType.Element) -> WrappedType.Element? { lockedWrite({ $0.remove(member) }) }

  @inlinable public func union(_ other: WrappedType) -> WrappedType { lockedRead({ $0.union(other) }) }
  @inlinable public func intersection(_ other: WrappedType) -> WrappedType { lockedRead({ $0.intersection(other) }) }
  @inlinable public func symmetricDifference(_ other: WrappedType) -> WrappedType { lockedRead({ $0.symmetricDifference(other) }) }

  @inlinable public mutating func formUnion(_ other: WrappedType) { lockedWrite({ $0.formUnion(other) }) }
  @inlinable public mutating func formIntersection(_ other: WrappedType) { lockedWrite({ $0.formIntersection(other) }) }
  @inlinable public mutating func formSymmetricDifference(_ other: WrappedType) { lockedWrite({ $0.formSymmetricDifference(other) }) }

  @inlinable public func union(_ other: ThreadSafe<WrappedType>) -> Self { .init(wrappedValue: other.lockedRead(self.union)) }
  @inlinable public func intersection(_ other: ThreadSafe<WrappedType>) -> Self { .init(wrappedValue: other.lockedRead(self.intersection)) }
  @inlinable public func symmetricDifference(_ other: ThreadSafe<WrappedType>) -> Self { .init(wrappedValue: other.lockedRead(self.symmetricDifference)) }

  @inlinable public mutating func formUnion(_ other: ThreadSafe<WrappedType>) { other.lockedRead({ other in lockedWrite({ $0.formUnion(other) }) }) }
  @inlinable public mutating func formIntersection(_ other: ThreadSafe<WrappedType>) { other.lockedRead({ other in lockedWrite({ $0.formIntersection(other) }) }) }
  @inlinable public mutating func formSymmetricDifference(_ other: ThreadSafe<WrappedType>) { other.lockedRead({ other in lockedWrite({ $0.formSymmetricDifference(other) }) }) }
}
