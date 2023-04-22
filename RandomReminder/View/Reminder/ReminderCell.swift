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
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(reminder.title)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .frame(height: 24)
                    }
                    Text(Reminder.getTimeFrameString(for: reminder.reminderTimeFrames))
                        .font(.caption)
                        .foregroundColor(.shadow)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .frame(height: 26)
                    Spacer()
                }
                Spacer()
            }
            
            HStack(spacing: 0) {
                ForEach(DaySelector.days.indices, id: \.self) { index in
                    Text(DaySelector.days[index])
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(reminder.daysActive[index] ? Color.dullNeutral.opacity(0.5) : .background.opacity(0.5))
                }
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
