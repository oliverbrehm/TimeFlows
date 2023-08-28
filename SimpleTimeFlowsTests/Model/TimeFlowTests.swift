//
//  TimeFlowTests.swift
//  SimpleTimeFlowsTests
//
//  Created by Oliver Brehm on 28.08.23.
//

import XCTest
@testable import SimpleTimeFlows

final class TimeFlowTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testCSVExport() throws {
        let sut = TimeFlow(name: "Test", items: [
            TimeItem(name: "Item1", seconds: 10),
            TimeItem(name: "Item2", seconds: 20)
        ])

        let csvString = try XCTUnwrap(String(data: sut.getCSVData(), encoding: .utf8))
        XCTAssertEqual(csvString.trimmingCharacters(in: .whitespacesAndNewlines),
            """
            name;seconds
            Item1;10
            Item2;20
            """)
    }
}
