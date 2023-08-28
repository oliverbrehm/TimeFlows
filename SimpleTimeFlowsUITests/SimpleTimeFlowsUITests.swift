//
//  SimpleTimeFlowsUITests.swift
//  SimpleTimeFlowsUITests
//
//  Created by Oliver Brehm on 25.08.23.
//

import XCTest

final class SimpleTimeFlowsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddTimeFlows() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchEnvironment["clear_data"] = "1"
        app.launch()


        let timeflowsNavigationBar = app.navigationBars["TimeFlows"]
        timeflowsNavigationBar.buttons["Add"].tap()

        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Text1")
        app.cells.buttons["Add"].tap()

        timeflowsNavigationBar.buttons["Add"].tap()
        nameTextField.tap()
        nameTextField.typeText("Text2")
        app.cells.buttons["Add"].tap()

        XCTAssertEqual(app.cells.count, 2)
    }

    func testAddItems() throws {
        let app = XCUIApplication()
        app.launchEnvironment["clear_data"] = "1"
        app.launch()

        app.navigationBars["TimeFlows"].buttons["Add"].tap()

        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Test")
        app.cells.buttons["Add"].tap()

        app.cells.buttons["Test"].tap()

        let cellsCount = app.cells.count

        app.cells.buttons["Add item"].tap()

        XCTAssertEqual(app.cells.count, cellsCount + 1)

        app.cells.firstMatch.tap()

        let titleTextField = app.textFields.firstMatch
        titleTextField.tap()
        titleTextField.typeText("Modified")

        app.pickerWheels.firstMatch.swipeUp()

        app.navigationBars.buttons.firstMatch.tap()

        let cellLabel = app.cells.firstMatch.buttons.firstMatch.label
        XCTAssertTrue(cellLabel.contains("Modified"))
        XCTAssertFalse(cellLabel.contains("60"))
    }

    func testRunTimeFlow() throws {
        let app = XCUIApplication()
        app.launchEnvironment["clear_data"] = "1"
        app.launch()

        // add test time flow
        app.navigationBars["TimeFlows"].buttons["Add"].tap()

        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Test")
        app.cells.buttons["Add"].tap()

        // navigate to test time flow screen
        app.cells.buttons["Test"].tap()

        let cellsCount = app.cells.count

        // add items
        app.cells.buttons["Add item"].tap()
        app.cells.buttons["Add item"].tap()
        app.cells.buttons["Add item"].tap()

        XCTAssertEqual(app.cells.count, cellsCount + 3)

        // configure items
        app.cells.element(boundBy: 0).tap()
        editItem(for: app, name: "1", seconds: 1)

        app.cells.element(boundBy: 1).tap()
        editItem(for: app, name: "2", seconds: 2)

        app.cells.element(boundBy: 2).tap()
        editItem(for: app, name: "3", seconds: 3)

        // navigate to action view
        app.navigationBars["Test"].buttons["Play"].tap()

        // start and pause timer
        app.buttons["Play"].firstMatch.tap()

        XCTAssertTrue(app.buttons["Pause"].waitForExistence(timeout: 1))

        app.buttons["Pause"].firstMatch.tap()

        XCTAssertTrue(app.buttons["Play"].waitForExistence(timeout: 1))

        // restart and wait for all timers to finish
        app.buttons["Play"].firstMatch.tap()
        XCTAssertTrue(app.buttons["Play"].waitForExistence(timeout: 10))
    }

    private func editItem(for app: XCUIApplication, name: String, seconds: UInt) {
        let titleTextField = app.textFields.firstMatch
        titleTextField.tap()
        titleTextField.typeText(name)

        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "\(seconds)")

        app.navigationBars.buttons.firstMatch.tap()
    }
}
