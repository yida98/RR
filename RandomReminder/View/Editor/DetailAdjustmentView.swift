//
//  DetailAdjustmentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct DetailAdjustmentView: View {
    @ObservedObject var viewModel: EditorViewModel

    @State var title: String = ""
    @State var frequency: Reminder.Frequency = .infrequent
    
    var body: some View {
        VStack {
            HStack {
                Text("Snooze")
                    .foregroundColor(.background)
                    .bold()
                    .frame(width: 100, height: 50)
                    .background {
                        AsymmetricalRoundedRectangle(10, 24, 24, 24)
                            .fill(Color.snooze)
                    }
                    .opacity(0.6)
                Spacer()
                Text("Delete")
                    .foregroundColor(.background)
                    .bold()
                    .frame(width: 100, height: 50)
                    .background {
                        AsymmetricalRoundedRectangle(24, 10, 24, 24)
                            .fill(Color.delete)
                    }
                    .opacity(0.6)
            }
            .padding(20)
            ColorSlider(viewModel: viewModel, padding: 40)
            TextField("Title", text: $title)
                .foregroundColor(.background)
                .font(.largeTitle)
                .padding(.horizontal, 40)
            VStack {
                FrequencySlider(currentFrequency: $frequency)
                    .frame(height: 10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                HStack(alignment: .bottom) {
                    Text("midnight")
                        .rotatedCaption(angle: Angle(degrees: -90))
                        .foregroundColor(.infrequent.opacity(0.3))
                    TimeSelector(systemImage: "sun.and.horizon", alignment: .top, phase: Angle(radians: Double.pi / 2), tint: .infrequent)
                        .frame(height: 50)
                    Text("midday")
                        .rotatedCaption(angle: Angle(degrees: 90))
                        .foregroundColor(.accentColor.opacity(0.3))
                }
                .padding(20)
                Text("ACTIVE TIMES")
                    .foregroundColor(.accentColor)
                    .bold()
                    .font(.caption)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.background, lineWidth: 1)
                    )
                HStack(alignment: .top) {
                    Text("midday")
                        .rotatedCaption(angle: Angle(degrees: -90))
                        .foregroundColor(.accentColor.opacity(0.3))
                    TimeSelector(systemImage: "moon.stars", alignment: .bottom, phase: Angle(radians: -Double.pi / 2), tint: .snooze)
                        .frame(height: 50)
                    Text("midnight")
                        .rotatedCaption(angle: Angle(degrees: 90))
                        .foregroundColor(.snooze.opacity(0.3))
                }
                .padding(20)
            }
            .padding(.vertical, 20)
            .background(
                AsymmetricalRoundedRectangle(10, 10, 50, 50)
                    .stroke(Color.background, lineWidth: 2)
            )
            .padding(20)
        }
        .adaptsToKeyboard()
        .ignoresSafeArea()
    }
}

extension Text {
    func rotatedCaption(angle: Angle) -> some View {
        self
            .font(.caption)
            .bold()
            .fixedSize()
            .frame(width: 10)
            .rotationEffect(angle)
    }
}

import Combine

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

extension View {
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
}


struct DetailAdjustmentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAdjustmentView(viewModel: EditorViewModel(), title: "thing")
    }
}
