//
//  FrequencySlider.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct FrequencySlider: View {
    @GestureState var dragLocation: CGPoint = .zero
    @Binding var currentFrequency: Reminder.Frequency
    
    var body: some View {
        HStack {
            ForEach(Reminder.Frequency.allCases, id: \.rawValue) { frequency in
                Rectangle()
                    .fill(getFill(for: frequency))
                    .id(frequency)
                    .background(dragObserver(frequency))
                    .onTapGesture {
                        updateFrequency(frequency)
                    }
            }
        }
        .highPriorityGesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragLocation, body: { value, state, transaction in
                    state = value.location
                })
        )
    }
    
    private func getFill(for frequency: Reminder.Frequency) -> some ShapeStyle {
        return frequency.rawValue <= currentFrequency.rawValue ? Color.neutralOn : Color.neutral
    }
    
    private func dragObserver(_ id: Reminder.Frequency) -> some View {
        GeometryReader { proxy in
            if proxy.frame(in: .global).contains(dragLocation) {
                updateFrequency(id)
            }
            return Rectangle().fill(Color.clear)
        }
    }
    
    private func updateFrequency(_ frequency: Reminder.Frequency) {
        if currentFrequency != frequency {
            DispatchQueue.main.async {
                self.currentFrequency = frequency
                let impactHeptic = UIImpactFeedbackGenerator(style: .light)
                impactHeptic.impactOccurred()
            }
        }
    }
}
