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
                    .font(.system(size: 35))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
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
                            timer.toggleRunning()
                        } label: {
                            Image(systemName: timer.isRunning ? "pause" : "play")
                                .font(.system(size: 30))
                                .foregroundStyle(.tint)
                                .animation(nil, value: timer.isRunning)
                        }
                        if timer.isActivated {
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
        }
        .padding(50)
    }
}

#Preview {
    ContentView()
}
