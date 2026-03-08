import XCTest
@testable import Swift_Timer

final class ProgressArcMathTests: XCTestCase {
    func testKnobPositionAtBounds() {
        let arc = ProgressArcView(progress: 0)
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
        let arc = ProgressArcView(progress: 0)
        let center = CGPoint(x: 100, y: 100)
        let top = CGPoint(x: 100, y: 0)

        let progress = arc.progressFromDrag(loc: top, center: center)

        XCTAssertEqual(progress, 0.5, accuracy: 0.001)
    }

    func testProgressFromDragProjectsLowerHalfTouchesToUpperArc() {
        let arc = ProgressArcView(progress: 0)
        let center = CGPoint(x: 100, y: 100)
        let belowCenter = CGPoint(x: 100, y: 160)

        let progress = arc.progressFromDrag(loc: belowCenter, center: center)

        XCTAssertEqual(progress, 0.5, accuracy: 0.001)
    }
}
