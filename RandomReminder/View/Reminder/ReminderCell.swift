//
//  ReminderCell.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct ReminderCell: View {
    var reminder: Reminder
    
    // TODO: Remove
    @State var frequency: Int = 1
    
    var body: some View {
        VStack {
            HStack(spacing: 14) {
                Text("🌴")
                    .font(.title)
                    .padding(10)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color(for: reminder.colorChoice))
                    )
                VStack(alignment: .leading) {
                    Spacer()
                    Text(title)
                        .font(.headline)
                    Text(reminder.getTimeFrameString())
                        .font(.caption)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
            }
            FrequencySlider(currentFrequency: $frequency)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
    }
    
    private func color(for choice: Int16) -> Color {
        return Reminder.colors[Int(choice) % 8]
    }
    
    private var title: String {
        reminder.title ?? ""
    }
}
