//
//  MainViewViewModelTests.swift
//  SimpleTimeFlowsTests
//
//  Created by Oliver Brehm on 28.08.23.
//

import XCTest
@testable import SimpleTimeFlows

final class MainViewViewModelTests: XCTestCase {
    var timeFlowService = TimeFlowService()

    override func setUpWithError() throws {
        timeFlowService.clear()
    }

    override func tearDownWithError() throws {}

    @MainActor private func getSut() -> MainView.ViewModel {
        let sut = MainView.ViewModel()
        sut.timeFlowService = timeFlowService
        return sut
    }

    @MainActor func testShowAddView() throws {
        let sut = getSut()

        sut.showAddFlowView()

        XCTAssertTrue(sut.showAddFlow)
    }

    @MainActor func testAddTimeFlow() throws {
        let sut = getSut()

        sut.addFlowName = "Test"
        sut.addFlow()

        XCTAssertEqual(timeFlowService.timeFlows.count, 1)

        let timeFlow = try XCTUnwrap(timeFlowService.timeFlows.first)
        XCTAssertEqual(timeFlow.name, "Test")
    }

    @MainActor func testAddEmpty() throws {
        let sut = getSut()

        sut.addFlowName = ""
        sut.addFlow()

        XCTAssertTrue(timeFlowService.timeFlows.isEmpty)
    }
}
