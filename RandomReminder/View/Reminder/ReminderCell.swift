//
//  ReminderCell.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct ReminderCell: View {
    @EnvironmentObject var delegate: AppData
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
                    Spacer(minLength: 0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(reminder.title)
                            .font(.headline)
                            .foregroundColor(titleColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .frame(height: 20)
                    }
                    HStack(alignment: .bottom) {
                        Text(Reminder.getTimeFrameString(for: reminder.reminderTimeFrames))
                            .font(.caption)
                            .foregroundColor(.shadow)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                            .frame(height: 26)
                    }
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
            FrequencySlider(currentFrequency: $reminder.frequency, baseColor: frequencySliderColor)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .snoozeOverlay(isSnoozed, shape: RoundedRectangle(cornerRadius: 20))
    }
    
    private var isSnoozed: Bool {
        guard let id = reminder.id else { return false }
        return delegate.isSnoozed(id)
    }
    
    private func color(for choice: Int) -> Color {
        return Reminder.colors[(choice) % 8]
    }
    
    private var titleColor: Color {
        guard let id = reminder.id, delegate.isSnoozed(id) else { return .accentColor }
        return .gray
    }
    
    private var frequencySliderColor: Color {
        guard let id = reminder.id, delegate.isSnoozed(id) else { return .bombardment }
        return .gray
    }
}

extension View {
    func snoozeOverlay<S: Shape>(_ snoozed: Bool, shape: S) -> some View {
        modifier(SnoozeOverlay(snoozed: snoozed, shape: shape))
    }
}

struct SnoozeOverlay<S: Shape>: ViewModifier {
    var snoozed: Bool
    var shape: S
    
    func body(content: Content) -> some View {
        if snoozed {
            content
                .overlay {
                    shape
                        .fill(Color.gray.opacity(0.8)).overlay {
                            Image(systemName: "moon.zzz.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                }
        } else {
            content
        }
    }
}
