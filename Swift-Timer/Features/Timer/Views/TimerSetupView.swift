import SwiftUI

struct TimerSetupView: View {
    @ObservedObject var timer: TimerViewModel

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("\(timer.timeInMinutes)")
                    .font(.system(size: 50, weight: .black))
                    .monospacedDigit()
                    .foregroundStyle(Color.appPrimaryText)
                    .accessibilityLabel("Selected minutes")
                    .accessibilityValue("\(timer.timeInMinutes)")
                    .accessibilityIdentifier("selectedMinutesText")

                TimerSelectorView { time in
                    timer.setTimer(min: time)
                }

                Button {
                    timer.start()
                } label: {
                    Text("Start")
                        .font(.title2.weight(.bold))
                        .frame(maxWidth: .infinity, minHeight: 64)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.appAccent)
                .buttonBorderShape(.roundedRectangle(radius: 18))
                .disabled(timer.count == 0)
                .accessibilityHint("Starts the timer with the selected minute value")
                .accessibilityIdentifier("startButton")
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
        }
    }
}

#Preview {
    TimerSetupView(timer: TimerViewModel())
}
