//
//  ColorCell.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct ColorCell: View {
    @ObservedObject var viewModel: EditorViewModel
    var index: Int
    @Binding var isUpdating: Bool
    @State private var firstLaunch: Bool = true
    
    var body: some View {
        GeometryReader { localProxy in
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    RoundedRectangle(cornerRadius: viewModel.reminder.colorChoice == index ? 20 : 10)
                        .fill(fillForTab(index).opacity(opacity(for: index)))
                        .tag(index)
                        .onChange(of: localProxy.frame(in: .global)) { newValue in
                            if newValue.minX >= 0 && newValue.minX <= 74, !firstLaunch {
                                viewModel.reminder.colorChoice = (index)
                                firstLaunch = true
                            }
                        }
                        .frame(width: viewModel.reminder.colorChoice == index ? 60 : 40, height: viewModel.reminder.colorChoice == index ? 60 : 40)
                        .animation(.easeIn(duration: 0.2), value: viewModel.reminder.colorChoice)
                        .animation(.easeIn(duration: 0.2), value: isUpdating)
                }
                .frame(width: 74, height: 74)
            }
            .frame(width: 74, height: 74)
        }
        .frame(width: 74, height: 74)
    }
    
    private func fillForTab(_ index: Int) -> Color {
        return Reminder.colors[index % 8]
    }
    
    private func opacity(for index: Int) -> CGFloat {
        if viewModel.reminder.colorChoice == (index) {
            return 1
        } else {
            if isUpdating {
                return 0.5
            } else {
                return 0
            }
        }
    }
}
