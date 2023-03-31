//
//  RemindersView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct RemindersView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @Binding var isOpen: Bool
    var body: some View {
        ZStack {
            if isOpen {
                ReminderCell(reminder: $viewModel.reminderUnderConstruction)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.reminders, id: \.id) { reminder in
                            Circle()
//                            ReminderCell(reminder: reminder)
                        }
                    }
                }.transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
            }
        }
        .frame(width: Constant.screenBounds.width - 100)
        .padding(30)
        .background(DynamicToolsBackdrop(isOpen: $isOpen))
        .mask(DynamicToolsBackdrop(isOpen: $isOpen))
        .animation(.spring(), value: isOpen)
    }
}
