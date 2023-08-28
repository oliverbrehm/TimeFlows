//
//  TimeFlowServiceTests.swift
//  SimpleTimeFlowsTests
//
//  Created by Oliver Brehm on 28.08.23.
//

import XCTest
@testable import SimpleTimeFlows

final class TimeFlowServiceTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testAddClear() throws {
        let sut = TimeFlowService()

        XCTAssertTrue(sut.timeFlows.isEmpty)

        sut.addTimeFlow(with: "Test1")
        XCTAssertEqual(sut.timeFlows.count, 1)
        XCTAssertEqual(sut.timeFlows[0].name, "Test1")

        sut.addTimeFlow(with: "Test2")
        XCTAssertEqual(sut.timeFlows.count, 2)
        XCTAssertEqual(sut.timeFlows[1].name, "Test2")

        sut.clear()

        XCTAssertTrue(sut.timeFlows.isEmpty)
    }
}

