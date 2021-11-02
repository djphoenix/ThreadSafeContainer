import RWLock

public struct ThreadSafeIterator<T: Sequence>: IteratorProtocol {
  public typealias Element = T.Element
  private let _locker: RLocker
  private var _iter: T.Iterator
  internal init(_ lock: RWLock, _ iter: T.Iterator) {
    _locker = RLocker(lock)
    _iter = iter
  }
  public mutating func next() -> T.Element? {
    return _iter.next()
  }
}

extension ThreadSafe: Sequence where WrappedType: Sequence {
  public typealias Element = WrappedType.Element
  public typealias Iterator = ThreadSafeIterator<WrappedType>

  public func makeIterator() -> Iterator {
    ThreadSafeIterator<WrappedType>(_lock, wrappedValue.makeIterator())
  }
}

extension ThreadSafe: Collection where WrappedType: Collection {
  @inlinable public var startIndex: WrappedType.Index { lockedRead({ $0.startIndex }) }
  @inlinable public var endIndex: WrappedType.Index { lockedRead({ $0.endIndex }) }
  @inlinable public func index(after i: WrappedType.Index) -> WrappedType.Index { lockedRead({ $0.index(after: i) }) }
  @inlinable public subscript(position: WrappedType.Index) -> WrappedType.Element { lockedRead({ $0[position] }) }
}

extension ThreadSafe: MutableCollection where WrappedType: MutableCollection {
  @inlinable public subscript(position: WrappedType.Index) -> WrappedType.Element {
    @inlinable get { lockedRead({ $0[position] }) }
    @inlinable set { lockedWrite({ $0[position] = newValue }) }
  }
}

extension ThreadSafe: RangeReplaceableCollection where WrappedType: RangeReplaceableCollection {
  @inlinable public init() { self.init(wrappedValue: .init()) }
  @inlinable public init(repeating repeatedValue: WrappedType.Element, count: Int) {
    self.init(wrappedValue: .init(repeating: repeatedValue, count: count))
  }
  @inlinable public mutating func replaceSubrange<C>(_ subrange: Range<WrappedType.Index>, with newElements: C) where C : Collection, WrappedType.Element == C.Element {
    lockedWrite { $0.replaceSubrange(subrange, with: newElements) }
  }
  @inlinable public mutating func append(_ newElement: WrappedType.Element) {
    lockedWrite { $0.append(newElement) }
  }
  @inlinable public mutating func append<S>(contentsOf newElements: S) where S : Sequence, WrappedType.Element == S.Element {
    lockedWrite { $0.append(contentsOf: newElements) }
  }
}
