//
//  ReminderCell.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct ReminderCell: View {
    var color: Color = .orange.opacity(0.5)
    var title: String = "Relax your shoulders"
    var description: String = "Occurs from 1:00 to 8:00, 19:30 to 23:30"
    
    // TODO: Remove
    @State var frequency: Reminder.Frequency = .infrequent
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text("🌴")
                    .font(.title)
                    .padding(10)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color)
                    )
                VStack(alignment: .leading) {
                    Spacer()
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
            }
            FrequencySlider(currentFrequency: $frequency)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        ReminderCell()
            .background(Color.baseColor)
    }
}
