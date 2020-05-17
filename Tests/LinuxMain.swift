import XCTest

import Antlr4Tests

var tests = [XCTestCaseEntry]()
tests += Antlr4Tests.allTests()
XCTMain(tests)
