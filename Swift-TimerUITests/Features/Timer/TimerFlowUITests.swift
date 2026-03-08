import XCTest

final class TimerFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSetupScreenLoadsAndStartActivatesTimerView() {
        XCTAssertTrue(app.staticTexts["selectedMinutesText"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.buttons["startButton"].exists)

        app.buttons["startButton"].tap()

        XCTAssertTrue(app.staticTexts["formattedTimeText"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["toggleRunButton"].exists)
        XCTAssertTrue(app.buttons["resetButton"].exists)
    }

    func testResetReturnsToSetupScreen() {
        app.buttons["startButton"].tap()
        XCTAssertTrue(app.buttons["resetButton"].waitForExistence(timeout: 2))

        app.buttons["resetButton"].tap()

        XCTAssertTrue(app.staticTexts["selectedMinutesText"].waitForExistence(timeout: 1))
        XCTAssertTrue(app.buttons["startButton"].exists)
    }
}
