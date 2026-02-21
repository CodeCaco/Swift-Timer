import Foundation
import SwiftUI

struct ProgressArc: View {
    let progress: CGFloat
    let start: CGFloat = 0
    let end: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: start, to: end)
                .stroke(Color.blue.opacity(0.6), lineWidth: 10)
                .rotationEffect(.degrees(180))
            
            Circle()
                .trim(from: start, to: progress * end)
                .stroke(Color.primary, lineWidth: 10)
                .rotationEffect(.degrees(180))
        }
    }
}

#Preview {
    ProgressArc(progress: 0.35)
}
