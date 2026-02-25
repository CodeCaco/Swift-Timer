import SwiftUI

struct ContentView: View {
    @StateObject private var timer = TimerModel()
    @State private var showReset = false
    let preset = [1,5,10,15]
    
    var body: some View {
        ZStack {
            ProgressArc(progress: CGFloat(timer.progress)) { p in
                timer.updateProgress(value: Double(p))
                if !timer.isRunning && timer.count > 0 {
                    showReset = true
                }
            }
            VStack {
                Text("\(timer.formattedTime)")
                    .font(.system(size: 35))
                HStack {
                    ForEach(preset, id: \.self) { min in
                        Button {
                            timer.setTimer(min: min)
                        } label: {
                            Image(systemName: "\(min).square")
                        }
                        .font(.system(size: 30))
                    }
                    .padding(5)
                }
                HStack {
                    if timer.count > 0 {
                        Button {
                            if !timer.isRunning && timer.count > 0 {
                                showReset = true
                            }
                            timer.isRunning.toggle()
                        } label: {
                            Image(systemName: timer.isRunning ? "pause" : "play")
                                .font(.system(size: 30))
                                .foregroundStyle(.tint)
                                .animation(nil, value: timer.isRunning)
                        }
                        if showReset {
                            Button {
                                timer.reset()
                            } label: {
                                Image(systemName: "stop")
                                    .font(.system(size: 30))
                            }
                        }
                    }
                }
            }
            .padding()
            .task(id: timer.isRunning) {
                await timer.runCountdown()
            }
            .onChange(of: timer.count) { _, newValue in
                if newValue == 0 {
                    showReset = false
                }
            }
        }
        .padding(50)
    }
}

#Preview {
    ContentView()
}
