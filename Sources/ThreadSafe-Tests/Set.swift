import XCTest
import ThreadSafeContainer

class SetTests: XCTestCase {
  let queue = DispatchQueue.global(qos: .userInitiated)
  let count = 100000

  func testInsert() {
    var arr = ThreadSafeSet<Int>()
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.insert(i)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testUpdate() {
    var arr = ThreadSafeSet<Int>((0 ..< count))
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.update(with: i)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testContains() {
    let arr = ThreadSafeSet<Int>((0 ..< count))
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async { [count] in
        let c0 = arr.contains(i)
        let c1 = arr.contains(i + count)
        XCTAssertTrue(c0)
        XCTAssertFalse(c1)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, count)
  }

  func testDelete() {
    var arr = ThreadSafeSet<Int>((0 ..< count))
    let ex = XCTestExpectation()
    ex.expectedFulfillmentCount = count
    (0 ..< count).forEach { i in
      queue.async {
        arr.remove(i)
        ex.fulfill()
      }
    }
    wait(for: [ex], timeout: 10)
    XCTAssertEqual(arr.count, 0)
  }

  func testEnumerate() {
    let arr = ThreadSafeSet<Int>((0 ..< count))
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
