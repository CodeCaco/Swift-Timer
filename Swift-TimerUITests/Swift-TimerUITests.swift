import XCTest

final class TimerFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSelectingPresetShowsStartControlAndInitialTime() {
        app.buttons["Set timer to 1 minutes"].tap()

        let startButton = app.buttons["Start timer"]
        let remainingTime = app.staticTexts["Remaining time"]

        XCTAssertTrue(startButton.waitForExistence(timeout: 1))
        XCTAssertTrue(remainingTime.exists)
        XCTAssertEqual(remainingTime.value as? String, "01:00")
    }

    func testStartPauseAndResetFlow() {
        app.buttons["Set timer to 1 minutes"].tap()
        app.buttons["Start timer"].tap()

        let pauseButton = app.buttons["Pause timer"]
        let resetButton = app.buttons["Reset timer"]

        XCTAssertTrue(pauseButton.waitForExistence(timeout: 1))
        XCTAssertTrue(resetButton.exists)

        pauseButton.tap()
        XCTAssertTrue(app.buttons["Start timer"].waitForExistence(timeout: 1))

        resetButton.tap()
        XCTAssertFalse(app.buttons["Start timer"].exists)
        XCTAssertFalse(app.buttons["Reset timer"].exists)
    }
}

final class SwiftTimerUITests: XCTestCase {
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
