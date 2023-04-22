//
//  FrequencyEditor.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import SwiftUI

struct FrequencyEditor: View {
    @ObservedObject var viewModel: EditorViewModel
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                HStack {
                    Text("FREQUENCY")
                        .subtitle()
                    Spacer()
                }
                FrequencySlider(currentFrequency: $viewModel.reminder.frequency)
                    .frame(height: 10)
            }
            .padding(.horizontal, 30)
            VStack(spacing: 30) {
                HStack {
                    Text("ACTIVE TIMES")
                        .subtitle()
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 10)
                HStack(alignment: .bottom) {
                    Text("0:00")
                        .rotatedCaption(angle: Angle(degrees: -90))
                        .foregroundColor(.infrequent.opacity(0.3))
                    TimeSelector(isOn: $viewModel.isOnMorning, systemImage: "sun.and.horizon", alignment: .top, phase: Angle(radians: Double.pi / 2), tint: .infrequent)
                        .frame(height: 50)
                    Text("12:00")
                        .rotatedCaption(angle: Angle(degrees: 90))
                        .foregroundColor(.accentColor.opacity(0.3))
                }
                DaySelector(daysSelected: $viewModel.reminder.daysActive)
                HStack(alignment: .top) {
                    Text("12:00")
                        .rotatedCaption(angle: Angle(degrees: -90))
                        .foregroundColor(.accentColor.opacity(0.3))
                    TimeSelector(isOn: $viewModel.isOnAfternoon, systemImage: "moon.stars", alignment: .bottom, phase: Angle(radians: -Double.pi / 2), tint: .snooze)
                        .frame(height: 50)
                    Text("0:00")
                        .rotatedCaption(angle: Angle(degrees: 90))
                        .foregroundColor(.snooze.opacity(0.3))
                }
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }
}
