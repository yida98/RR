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
        VStack {
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
            .padding(.bottom, 20)
            HStack(alignment: .bottom) {
                Text("midnight")
                    .rotatedCaption(angle: Angle(degrees: -90))
                    .foregroundColor(.infrequent.opacity(0.3))
                TimeSelector(isOn: $viewModel.isOnMorning, systemImage: "sun.and.horizon", alignment: .top, phase: Angle(radians: Double.pi / 2), tint: .infrequent)
                    .frame(height: 50)
                Text("midday")
                    .rotatedCaption(angle: Angle(degrees: 90))
                    .foregroundColor(.accentColor.opacity(0.3))
            }
            .padding(20)
            Text("ACTIVE TIMES")
                .subtitle()
                .bold()
                .padding(8)
            HStack(alignment: .top) {
                Text("midday")
                    .rotatedCaption(angle: Angle(degrees: -90))
                    .foregroundColor(.accentColor.opacity(0.3))
                TimeSelector(isOn: $viewModel.isOnAfternoon, systemImage: "moon.stars", alignment: .bottom, phase: Angle(radians: -Double.pi / 2), tint: .snooze)
                    .frame(height: 50)
                Text("midnight")
                    .rotatedCaption(angle: Angle(degrees: 90))
                    .foregroundColor(.snooze.opacity(0.3))
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }
}
