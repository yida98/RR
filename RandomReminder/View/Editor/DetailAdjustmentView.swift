//
//  DetailAdjustmentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct DetailAdjustmentView: View {
    @ObservedObject var viewModel: EditorViewModel
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            UtilityBar(viewModel: viewModel, isOpen: $isOpen)
            ColorPicker(viewModel: viewModel)
            TitleEditor(viewModel: viewModel)
            FrequencyEditor(viewModel: viewModel)
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
