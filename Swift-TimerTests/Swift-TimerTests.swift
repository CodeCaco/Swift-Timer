import XCTest
@testable import Swift_Timer

@MainActor
final class TimerModelTests: XCTestCase {
    func testSetTimerInitializesState() {
        let model = TimerModel()

        model.setTimer(min: 1)

        XCTAssertEqual(model.count, 60)
        XCTAssertEqual(model.formattedTime, "01:00")
        XCTAssertFalse(model.isRunning)
        XCTAssertFalse(model.isActivated)
        XCTAssertEqual(model.progress, 1)
    }

    func testStartAndPauseUpdateRunningStateAndRemainingTime() async {
        let model = TimerModel()
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
        let model = TimerModel()
        model.setTimer(min: 1)
        model.updateProgress(value: 1.0 / 60.0) // One second remaining.
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
        let model = TimerModel()
        model.setTimer(min: 1)

        model.updateProgress(value: -0.5)
        XCTAssertEqual(model.count, 0)

        model.updateProgress(value: 2)
        XCTAssertEqual(model.count, 60)

        model.updateProgress(value: 0.5)
        XCTAssertEqual(model.count, 30)
    }
}

final class ProgressArcMathTests: XCTestCase {
    func testKnobPositionAtBounds() {
        let arc = ProgressArc(progress: 0)
        let center = CGPoint(x: 100, y: 100)
        let radius: CGFloat = 50

        let left = arc.knobPosition(p: 0, r: radius, c: center)
        let right = arc.knobPosition(p: 1, r: radius, c: center)

        XCTAssertEqual(left.x, center.x - radius, accuracy: 0.001)
        XCTAssertEqual(left.y, center.y, accuracy: 0.001)
        XCTAssertEqual(right.x, center.x + radius, accuracy: 0.001)
        XCTAssertEqual(right.y, center.y, accuracy: 0.001)
    }

    func testProgressFromDragAtTopIsHalf() {
        let arc = ProgressArc(progress: 0)
        let center = CGPoint(x: 100, y: 100)
        let top = CGPoint(x: 100, y: 0)

        let progress = arc.progressFromDrag(loc: top, center: center)

        XCTAssertEqual(progress, 0.5, accuracy: 0.001)
    }

    func testProgressFromDragProjectsLowerHalfTouchesToUpperArc() {
        let arc = ProgressArc(progress: 0)
        let center = CGPoint(x: 100, y: 100)
        let belowCenter = CGPoint(x: 100, y: 160)

        let progress = arc.progressFromDrag(loc: belowCenter, center: center)

        XCTAssertEqual(progress, 0.5, accuracy: 0.001)
    }
}
