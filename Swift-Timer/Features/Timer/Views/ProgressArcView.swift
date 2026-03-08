import Foundation
import SwiftUI

struct ProgressArcView: View {
    let progress: CGFloat
    let start: CGFloat = 0
    let end: CGFloat = 0.5
    let lineWidth: CGFloat = 12
    let onDragProgress: (CGFloat) -> Void

    init(progress: CGFloat, onDragProgress: @escaping (CGFloat) -> Void = { _ in }) {
        self.progress = progress
        self.onDragProgress = onDragProgress
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - lineWidth / 2
            let knob = min(max(radius * 0.1, 14), 24)
            let p = min(max(progress, 0), 1)

            ZStack {
                Circle()
                    .trim(from: start, to: end)
                    .stroke(
                        Color.appTrack,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))
                    .padding(lineWidth / 2)

                Circle()
                    .trim(from: start, to: p * end)
                    .stroke(
                        Color.appAccent,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))
                    .padding(lineWidth / 2)

                Circle()
                    .fill(Color.appPrimaryText)
                    .frame(width: knob, height: knob)
                    .overlay {
                        Circle()
                            .stroke(Color.appAccent, lineWidth: 2)
                    }
                    .position(knobPosition(p: p, r: radius, c: center))
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("arcSpace"))
                            .onChanged { newLoc in
                                onDragProgress(progressFromDrag(loc: newLoc.location, center: center))
                            }
                    )
            }
        }
        .coordinateSpace(name: "arcSpace")
    }

    func knobPosition(p: CGFloat, r: CGFloat, c: CGPoint) -> CGPoint {
        let a = CGFloat.pi * (1 - p)
        return CGPoint(x: c.x + r * cos(a), y: c.y - r * sin(a))
    }

    func progressFromDrag(loc: CGPoint, center: CGPoint) -> CGFloat {
        let dx = loc.x - center.x
        let dy = center.y - loc.y
        let angle = atan2(dy, dx)
        let projectedAngle = angle < 0 ? abs(angle) : angle
        let clampedAngle = min(max(projectedAngle, 0), .pi)
        return 1 - (clampedAngle / .pi)
    }
}

#Preview {
    ProgressArcView(progress: 0.35)
}
