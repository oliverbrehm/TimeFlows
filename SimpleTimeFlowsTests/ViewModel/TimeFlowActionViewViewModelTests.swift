//
//  TimeFlowActionViewViewModelTests.swift
//  SimpleTimeFlowsTests
//
//  Created by Oliver Brehm on 28.08.23.
//

import XCTest
@testable import SimpleTimeFlows

final class TimeFlowActionViewViewModelTests: XCTestCase {
    var timeFlow = TimeFlow(name: "Test", items: [])

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    @MainActor private func getSut() -> TimeFlowActionView.ViewModel {
        let sut = TimeFlowActionView.ViewModel()
        sut.timeFlow = timeFlow
        return sut
    }

    @MainActor func testShowAddView() throws {
        let sut = getSut()

        timeFlow.addItem()
        timeFlow.items[0].name = "Test1"
        timeFlow.items[0].seconds = 1

        timeFlow.addItem()
        timeFlow.items[1].name = "Test2"
        timeFlow.items[1].seconds = 2

        timeFlow.addItem()
        timeFlow.items[2].name = "Test3"
        timeFlow.items[2].seconds = 3

        sut.onAppear()

        sut.nextItem()
        XCTAssertEqual(sut.currentItem.name, "Test2")

        sut.previousItem()
        XCTAssertEqual(sut.currentItem.name, "Test1")

        sut.nextItem()
        sut.nextItem()
        XCTAssertEqual(sut.currentItem.name, "Test3")

        sut.nextItem()
        XCTAssertEqual(sut.currentItem.name, "Test1")

        sut.previousItem()
        XCTAssertEqual(sut.currentItem.name, "Test1")

        sut.running = true

        sleep(3)

        XCTAssertTrue(sut.running)
    }
}
