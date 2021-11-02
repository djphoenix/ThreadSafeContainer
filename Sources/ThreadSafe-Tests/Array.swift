import XCTest
import ThreadSafeContainer

class ArrayTests: XCTestCase {
  let queue = DispatchQueue.global(qos: .userInitiated)
  let count = 100000

  func testAppend() {
    var arr = ThreadSafeArray<Int>()
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.append(i)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testInsert() {
    var arr = ThreadSafeArray<Int>()
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.insert(i, at: 0)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testDeleteFirst() {
    var arr = ThreadSafeArray<Int>.init(repeating: 0, count: count)
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.removeFirst()
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, 0)
  }

  func testEnumerate() {
    let arr = ThreadSafeArray<Int>((0 ..< count))
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
