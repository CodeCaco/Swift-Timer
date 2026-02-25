import Foundation
import SwiftUI

struct ProgressArc: View {
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
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let radius = min(size.width, size.height) / 2 - lineWidth / 2
            let knob = min(max(radius * 0.1, 14), 24)
            let p = min(max(progress, 0), 1)
            
            ZStack {
                Circle()
                    .trim(from: start, to: end)
                    .stroke(
                        Color.blue.opacity(0.4),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))
                    .padding(lineWidth / 2)
                
                Circle()
                    .trim(from: start, to: p * end)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(180))
                    .padding(lineWidth / 2)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: knob, height: knob)
                    .overlay {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                    }
                    .position(knobPosition(p: p, r: radius, c: center))
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("arcSpace"))
                            .onChanged {newLoc in
                                onDragProgress(progressFromDrag(loc: newLoc.location, center: center))
                            }
                    )
            }
        }
        .coordinateSpace(name: "arcSpace")
    }
    
    // Calculate position based on the progress with radius and center
    func knobPosition(p: CGFloat, r: CGFloat, c: CGPoint) -> CGPoint {
        let a = CGFloat.pi * (1 - p)
        return CGPoint(x: c.x + r*cos(a), y: c.y - r*sin(a))
    }
    
    func progressFromDrag(loc: CGPoint, center: CGPoint) -> CGFloat{
        let dx = loc.x - center.x
        let dy = center.y - loc.y
        let angle = atan2(dy, dx)
        let clampedAngle = min(max(angle, 0), .pi)
        let newProgress = 1 - (clampedAngle / .pi)
       return newProgress
    }
}

#Preview {
    ProgressArc(progress: 0.35)
}
