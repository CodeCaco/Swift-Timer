import SwiftUI

struct ContentView: View {
    @StateObject private var timer = TimerModel()
    let preset = [1,5,10,15]
    
    var body: some View {
        ZStack {
            ProgressArc(progress: CGFloat(timer.progress)) { p in
                timer.updateProgress(value: Double(p))
            }
            VStack {
                Text("\(timer.formattedTime)")
                    .font(.largeTitle.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Remaining time")
                    .accessibilityValue(timer.formattedTime)
                HStack {
                    ForEach(preset, id: \.self) { min in
                        Button {
                            timer.setTimer(min: min)
                        } label: {
                            Image(systemName: "\(min).square")
                        }
                        .font(.title2)
                        .accessibilityLabel("Set timer to \(min) minutes")
                    }
                    .padding(5)
                }
                HStack {
                    if timer.count > 0 {
                        Button {
                            timer.toggleRunning()
                        } label: {
                            Image(systemName: timer.isRunning ? "pause" : "play")
                                .font(.title2)
                                .foregroundStyle(.tint)
                                .animation(nil, value: timer.isRunning)
                        }
                        .accessibilityLabel(timer.isRunning ? "Pause timer" : "Start timer")
                        if timer.isActivated {
                            Button {
                                timer.reset()
                            } label: {
                                Image(systemName: "stop")
                                    .font(.title2)
                            }
                            .accessibilityLabel("Reset timer")
                        }
                    }
                }
            }
            .padding()
            .task(id: timer.isRunning) {
                await timer.runCountdown()
            }
        }
        .padding(50)
    }
}

#Preview {
    ContentView()
}
