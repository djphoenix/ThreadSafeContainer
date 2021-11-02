extension ThreadSafe: Equatable where WrappedType: Equatable {
  @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.lockedRead({ lhs in rhs.lockedRead({ rhs in lhs == rhs }) })
  }
  @inlinable public static func == (lhs: Self, rhs: WrappedType) -> Bool {
    lhs.lockedRead({ lhs in lhs == rhs })
  }
  @inlinable public static func == (lhs: WrappedType, rhs: Self) -> Bool {
    rhs.lockedRead({ rhs in lhs == rhs })
  }
}
