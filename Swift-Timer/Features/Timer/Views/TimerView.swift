import SwiftUI

struct TimerView: View {
    @ObservedObject var timer: TimerViewModel

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ProgressArcView(progress: CGFloat(timer.progress)) { newProgress in
                timer.updateProgress(value: Double(newProgress))
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal, 24)
            .padding(.vertical, 40)

            VStack(spacing: 50) {
                Text(timer.formattedTime)
                    .font(.system(size: 44, weight: .black))
                    .monospacedDigit()
                    .foregroundStyle(Color.appPrimaryText)
                    .accessibilityLabel("Formatted time")
                    .accessibilityValue(timer.formattedTime)
                    .accessibilityIdentifier("formattedTimeText")

                HStack(spacing: 24) {
                    Button {
                        timer.toggleRunning()
                    } label: {
                        Image(systemName: timer.isRunning ? "pause" : "play")
                            .font(.title2)
                            .foregroundStyle(Color.appAccent)
                            .animation(nil, value: timer.isRunning)
                    }
                    .accessibilityLabel(timer.isRunning ? "Pause timer" : "Start timer")
                    .accessibilityIdentifier("toggleRunButton")

                    Button {
                        timer.reset()
                    } label: {
                        Image(systemName: "stop")
                            .font(.title2)
                            .foregroundStyle(Color.appAccent)
                    }
                    .accessibilityLabel("Reset timer")
                    .accessibilityIdentifier("resetButton")
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    TimerView(timer: TimerViewModel())
}
