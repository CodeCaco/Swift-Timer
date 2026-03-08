import SwiftUI

struct AppRootView: View {
    @StateObject private var timer = TimerViewModel()

    var body: some View {
        Group {
            if timer.isActivated {
                TimerView(timer: timer)
            } else {
                TimerSetupView(timer: timer)
            }
        }
        .task(id: timer.isRunning) {
            await timer.runCountdown()
        }
    }
}

#Preview {
    AppRootView()
}
