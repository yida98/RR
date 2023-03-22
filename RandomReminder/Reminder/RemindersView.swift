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
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    ReminderCell()
                }
            }
            .padding(40)
            .background(
                DynamicToolsBackdropShape(isOpen: $isOpen, proxy: proxy)
                    .fill(Color.background)
            )
            .clipShape(DynamicToolsBackdropShape(isOpen: $isOpen, proxy: proxy))
            .animation(.linear, value: isOpen)
        }
    }
}
