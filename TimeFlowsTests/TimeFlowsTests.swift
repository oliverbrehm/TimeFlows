//
//  TimeFlowsTests.swift
//  TimeFlowsTests
//
//  Created by Oliver Brehm on 14.07.23.
//

import XCTest
@testable import TimeFlows
import ViewInspector

final class TimeFlowsTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testExample() throws {
        let sut = EditItemView(item: TimeItem(name: "Test", seconds: 60))

        let pickerForEach = try sut.inspect().find(ViewType.Picker.self)[0].forEach()

        XCTAssertEqual(pickerForEach.count, 599)

        XCTAssertEqual(try pickerForEach[0].text().string(), "1")
        XCTAssertEqual(try pickerForEach[1].text().string(), "2")
    }

}
