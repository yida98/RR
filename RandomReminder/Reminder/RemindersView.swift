//
//  RemindersView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct RemindersView: View {
    @Binding var isOpen: Bool
    var body: some View {
        ZStack {
            if isOpen {
                ReminderCell()
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(0..<5) { ind in
                            ReminderCell()
                        }
                    }
                }.transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
            }
        }
        .padding(40)
        .background(DynamicToolsBackdrop(isOpen: $isOpen))
        .mask(DynamicToolsBackdrop(isOpen: $isOpen))
        .animation(.spring(), value: isOpen)
    }
}
