//
//  DetailAdjustmentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct DetailAdjustmentView: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Snooze")
                    .font(.subheadline)
                    .foregroundColor(.snooze)
                    .bold()
                    .frame(width: 80, height: 36)
                    .background {
                        AsymmetricalRoundedRectangle(10, 16, 16, 16)
                            .stroke(Color.snooze, lineWidth: 2)
                    }
                    .opacity(0.6)
                Spacer()
                Text("Delete")
                    .font(.subheadline)
                    .foregroundColor(.delete)
                    .bold()
                    .frame(width: 80, height: 36)
                    .background {
                        AsymmetricalRoundedRectangle(16, 10, 16, 16)
                            .stroke(Color.delete, lineWidth: 2)
                    }
                    .opacity(0.6)
            }
            .padding(.horizontal, 30)
            ColorSlider(viewModel: viewModel, padding: 40)
            VStack {
                HStack {
                    Text("TITLE")
                        .subtitle()
                    Spacer()
                }
                TextField("Title", text: $viewModel.reminder.title)
                    .foregroundColor(.accentColor)
                    .bold()
                    .font(.largeTitle)
            }
            .padding(.horizontal, 50)
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
        .padding(.top, 10)
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
    
    func subtitle() -> some View {
        self
            .font(.caption)
            .bold()
            .foregroundColor(.accentColor.opacity(0.5))
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
