import Darwin

public final class RWLock {
  private var _lock = pthread_rwlock_t()
  public init() { pthread_rwlock_init(&_lock, nil) }
  public func rdlock() { pthread_rwlock_rdlock(&_lock) }
  public func rwlock() { pthread_rwlock_wrlock(&_lock) }
  public func unlock() { pthread_rwlock_unlock(&_lock) }

  @inlinable public func lockedRead<T>(_ work: () throws -> T) rethrows -> T {
    rdlock()
    let res = try work()
    unlock()
    return res
  }
  @inlinable public func lockedWrite<T>(_ work: () throws -> T) rethrows -> T {
    rwlock()
    let res = try work()
    unlock()
    return res
  }
}

public class RLocker {
  public let lock: RWLock
  @inlinable public init(_ lock: RWLock) {
    self.lock = lock
    lock.rdlock()
  }
  deinit { lock.unlock() }
}

public class WLocker {
  public let lock: RWLock
  @inlinable public init(_ lock: RWLock) {
    self.lock = lock
    lock.rdlock()
  }
  deinit { lock.unlock() }
}
