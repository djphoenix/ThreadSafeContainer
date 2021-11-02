import RWLock

@propertyWrapper public struct ThreadSafe<WrappedType> {
  private class PtrWrap {
    var val: WrappedType
//    init() { ptr = .allocate(capacity: 1) }
    init(_ value: WrappedType) { val = value }
//    deinit { ptr.pointee ptr.deallocate() }
  }

  public typealias WrappedType = WrappedType
  public var wrappedValue: WrappedType {
    get { _lock.lockedRead({ _storage.val }) }
    set { _lock.lockedWrite({ _storage.val = newValue }) }
  }
  public init(wrappedValue: WrappedType) { _storage = .init(wrappedValue) }
  internal let _lock: RWLock = .init()
  private let _storage: PtrWrap

  public func lockedRead<R>(_ work: (WrappedType) throws -> R) rethrows -> R {
    try _lock.lockedRead({ try work(_storage.val) })
  }
  public mutating func lockedWrite<R>(_ work: (inout WrappedType) throws -> R) rethrows -> R {
    try _lock.lockedWrite({ try work(&_storage.val) })
  }
}

public typealias ThreadSafeArray<Element> = ThreadSafe<Array<Element>>
public typealias ThreadSafeSet<Element: Hashable> = ThreadSafe<Set<Element>>
public typealias ThreadSafeDictionary<Key: Hashable, Value> = ThreadSafe<Dictionary<Key, Value>>

public protocol EmptyInitializable { init() }
extension Dictionary: EmptyInitializable {}

public extension ThreadSafe where WrappedType: EmptyInitializable {
  init() { self.init(wrappedValue: .init()) }
}
