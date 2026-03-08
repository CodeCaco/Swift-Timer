import XCTest
@testable import Swift_Timer

@MainActor
final class TimerViewModelTests: XCTestCase {
    func testSetTimerInitializesState() {
        let model = TimerViewModel()

        model.setTimer(min: 1)

        XCTAssertEqual(model.count, 60)
        XCTAssertEqual(model.formattedTime, "01:00")
        XCTAssertFalse(model.isRunning)
        XCTAssertFalse(model.isActivated)
        XCTAssertEqual(model.progress, 1)
    }

    func testStartAndPauseUpdateRunningStateAndRemainingTime() async {
        let model = TimerViewModel()
        model.setTimer(min: 1)
        model.start()

        let countdownTask = Task { await model.runCountdown() }
        defer { countdownTask.cancel() }

        try? await Task.sleep(for: .milliseconds(350))
        model.pause()

        XCTAssertFalse(model.isRunning)
        XCTAssertTrue(model.isActivated)
        XCTAssertGreaterThan(model.count, 0)
        XCTAssertLessThan(model.count, 60)
    }

    func testCountdownCompletionResetsState() async {
        let model = TimerViewModel()
        model.setTimer(min: 1)
        model.updateProgress(value: 1.0 / 60.0)
        model.start()

        let countdownTask = Task { await model.runCountdown() }
        defer { countdownTask.cancel() }

        try? await Task.sleep(for: .seconds(2))

        XCTAssertEqual(model.count, 0)
        XCTAssertFalse(model.isRunning)
        XCTAssertFalse(model.isActivated)
        XCTAssertEqual(model.progress, 0)
    }

    func testUpdateProgressClampsInputRange() {
        let model = TimerViewModel()
        model.setTimer(min: 1)

        model.updateProgress(value: -0.5)
        XCTAssertEqual(model.count, 0)

        model.updateProgress(value: 2)
        XCTAssertEqual(model.count, 60)

        model.updateProgress(value: 0.5)
        XCTAssertEqual(model.count, 30)
    }
}
