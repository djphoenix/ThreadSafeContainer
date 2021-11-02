import XCTest
import ThreadSafeContainer

class DictionaryTests: XCTestCase {
  let queue = DispatchQueue.global(qos: .userInitiated)
  let count = 100000

  func testInsert() {
    var arr = ThreadSafeDictionary<Int,Int>()
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr[i] = i
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testGetOrCreate() {
    var arr = ThreadSafeDictionary<Int,Int>()
    let iex = XCTestExpectation()
    iex.expectedFulfillmentCount = count * 3
    let cex = XCTestExpectation()
    cex.expectedFulfillmentCount = count
    (0 ..< count * 3).forEach { i in
      queue.async {
        _ = arr.getOrCreate(i / 3, create: { cex.fulfill(); return i })
        iex.fulfill()
      }
    }
    wait(for: [iex, cex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testDelete() {
    var arr = ThreadSafeDictionary<Int,Int>(wrappedValue: .init(uniqueKeysWithValues: (0 ..< count).map({ ($0, $0) })))
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr[i] = nil
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, 0)
  }

  func testEnumerate() {
    let arr = ThreadSafeDictionary<Int,Int>(wrappedValue: .init(uniqueKeysWithValues: (0 ..< count).map({ ($0, $0) })))
    let ex = XCTestExpectation()
    let trycnt = 100
    ex.expectedFulfillmentCount = trycnt
    (0 ..< trycnt).forEach { i in
      queue.async { [count] in
        if arr.reduce(0, { a, _ in a + 1 }) != count {
          XCTFail("invalid reduce count")
        }
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
  }
}
