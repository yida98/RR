//
//  ReminderCell.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct ReminderCell: View {
    @Binding private var reminder: DummyReminder
    
    init(reminder: Binding<DummyReminder>) {
        self._reminder = reminder
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 14) {
                Text(reminder.icon)
                    .font(.title)
                    .padding(10)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color(for: reminder.colorChoice))
                    )
                VStack(alignment: .leading) {
                    Spacer()
                    Text(reminder.title)
                        .font(.headline)
                    Text(Reminder.getTimeFrameString(for: reminder.reminderTimeFrames))
                        .font(.caption)
                        .foregroundColor(.shadow)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 30)
                }
                Spacer()
            }
            FrequencySlider(currentFrequency: $reminder.frequency)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
    }
    
    private func color(for choice: Int) -> Color {
        return Reminder.colors[(choice) % 8]
    }
}
