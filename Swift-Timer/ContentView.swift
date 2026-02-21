import SwiftUI

struct ContentView: View {
    @StateObject private var timer = TimerModel()
    
    var body: some View {
        VStack {
            HStack {
                Button("1") {timer.SetTimer(min: 1)}
                Button("5") {timer.SetTimer(min: 5)}
                Button("10") {timer.SetTimer(min: 10)}
                Button("15") {timer.SetTimer(min: 15)}
            }
            Button {
                timer.isRunning.toggle()
            } label: {
                Image(systemName: timer.isRunning ? "pause" : "play")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .animation(nil, value: timer.isRunning)
            }
            Text("time:\(timer.formattedTime)")
            ProgressArc(progress: CGFloat(timer.progress))
            Button("Reset") {
                timer.isRunning = false
                timer.count = 0
            }
        }
        .padding()
        .task(id: timer.isRunning) {
            await timer.RunCountdown()
        }
    }
}

#Preview {
    ContentView()
}
