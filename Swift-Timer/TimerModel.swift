import Foundation

@MainActor
class TimerModel: ObservableObject {
    @Published private(set) var isActivated = false
    @Published private(set) var isRunning = false
    @Published private(set) var count = 0
    private var total = 0
    private let clock = ContinuousClock()
    private var endInstant: ContinuousClock.Instant? = nil
    
    func setTimer(min: Int) {
        count = 60 * min
        total = count
        isRunning = false
        isActivated = false
        endInstant = nil
    }
    
    func runCountdown() async {
        guard isRunning else { return }
        while isRunning {
            do {
                try await Task.sleep(for: .milliseconds(100))
            } catch {
                return
            }
            guard isRunning else { break }
            if let endInstant {
                count = remainingSeconds(until: endInstant)
                if count == 0 {
                    reset()
                }
            } else {
                reset()
            }
        }
    }
    
    func start() {
        guard count > 0 else { return }
        isActivated = true
        isRunning = true
        endInstant = clock.now.advanced(by: .seconds(count))
    }
    
    func pause() {
        guard let endInstant else { return }
        count = remainingSeconds(until: endInstant)
        self.endInstant = nil
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
        endInstant = nil
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
        if isRunning {
            endInstant = clock.now.advanced(by: .seconds(count))
        }
    }

    private func remainingSeconds(until endInstant: ContinuousClock.Instant) -> Int {
        let remainingDuration = max(.zero, clock.now.duration(to: endInstant))
        let components = remainingDuration.components
        let seconds = Double(components.seconds) + Double(components.attoseconds) / 1_000_000_000_000_000_000
        return Int(seconds.rounded(.down))
    }
}
