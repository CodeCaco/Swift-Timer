import SwiftUI

struct TimerSelectorView: View {
    @State private var selectedMinute: Int? = 1
    let onSelect: (Int) -> Void

    private let spacing: CGFloat = 20
    private let maxVisibleItems: CGFloat = 11
    private let maxBarHeight: CGFloat = 280
    private let minBarHeight: CGFloat = 90
    private let heightStep: CGFloat = 18

    init(onSelect: @escaping (Int) -> Void = { _ in }) {
        self.onSelect = onSelect
    }

    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width
            let itemWidth = max(6, (availableWidth - spacing * (maxVisibleItems - 1)) / maxVisibleItems)
            let sideInset = max(0, (availableWidth - itemWidth) / 2)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .bottom, spacing: spacing) {
                    ForEach(1...120, id: \.self) { minute in
                        let height = barHeight(for: minute)
                        Rectangle()
                            .fill(minute == selectedMinute ? Color.appPrimaryText : Color.appTrack)
                            .frame(width: itemWidth, height: height)
                            .id(minute)
                            .animation(
                                .interactiveSpring(response: 0.35, dampingFraction: 0.82, blendDuration: 0.2),
                                value: selectedMinute
                            )
                    }
                }
                .frame(height: maxBarHeight)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, sideInset, for: .scrollContent)
            .scrollPosition(id: $selectedMinute)
            .animation(
                .interactiveSpring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.2),
                value: selectedMinute
            )
            .onChange(of: selectedMinute) { _, newValue in
                guard let newValue else { return }
                onSelect(newValue)
            }
            .onAppear {
                if let selectedMinute {
                    onSelect(selectedMinute)
                }
            }
        }
        .frame(height: maxBarHeight)
    }

    private func barHeight(for minute: Int) -> CGFloat {
        guard let selectedMinute else { return minBarHeight }
        let distance = abs(minute - selectedMinute)
        let tapered = maxBarHeight - (CGFloat(distance) * heightStep)
        return max(minBarHeight, tapered)
    }
}

#Preview {
    TimerSelectorView()
}
