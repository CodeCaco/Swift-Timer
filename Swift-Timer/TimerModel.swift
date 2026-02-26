import Foundation

@MainActor
class TimerModel: ObservableObject {
    @Published var isActivated = false
    @Published var isRunning = false
    @Published var count = 0
    private var total = 0
    
    func setTimer(min: Int) {
        count = 60 * min
        total = count
        isRunning = false
        isActivated = false
    }
    
    func runCountdown() async {
        guard isRunning else { return }
        while isRunning {
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                return
            }
            guard isRunning else { break }
            if count > 0 {
                count -= 1
            } else {
                count = 0
                total = 0
                isRunning = false
                isActivated = false
            }
        }
    }
    
    func start() {
        guard count > 0 else { return }
        isActivated = true
        isRunning = true
    }
    
    func pause() {
        isRunning = false
    }
    
    func toggleRunning() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }
    
    func reset() {
        isRunning = false
        count = 0
        total = 0
        isActivated = false
    }
    
    var formattedTime: String {
        let minutes = count / 60
        let seconds = count % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double{
        guard total > 0 else { return 0 }
        return 1 - Double(total - count) / Double(total)
    }
    
    func updateProgress(value: Double) {
        guard total > 0 else { return }

        let clamped = min(max(value, 0), 1)
        count = Int((Double(total) * clamped).rounded())
    }
}
