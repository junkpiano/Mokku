import XCTest

import mokkuTests

var tests = [XCTestCaseEntry]()
tests += mokkuTests.allTests()
XCTMain(tests)